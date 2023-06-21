//
//  AlarmService.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu on 4.06.2023.
//

import Foundation
import SwiftUI
import UIKit
import UserNotifications
import AVFoundation
import CoreHaptics

struct TimestampAndAlarm {
    let timestamp: Double
    let alarm: AlarmModel
}

final class AlarmService {
    private var awakeDetectionService: AwakeDetectionService?
    static let shared = AlarmService()
    @Published var nearestActiveAlarm: AlarmModel?

    private var alarms: [AlarmModel] = []
    private var timer: Timer?
    private var lastTriggeredAlarm: AlarmModel?
    private var packageAlarms: [AlarmModel] = []

    @Published var sleepViewModelSensorText: String = ""
    private var awakeStateDidChange: ((Bool) -> Void)?
    var isAwake: Bool = false {
        didSet {
            awakeStateDidChange?(isAwake)
        }
    }

    private var isAwakeProgressing: Bool = false

    // MARK: - Monitoring Alarms

    private init() {
        checkNearestActiveAlarm()
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
            self.checkNearestActiveAlarm()
        }
    }

    // MARK: - PackageAlarms methods

    func clearPackageAlarms() {
        packageAlarms = []
    }

    func addPackageAlarms(alarm: AlarmModel) {
        packageAlarms.append(alarm)
    }

    func getPackageAlarms() -> [AlarmModel] {
        return packageAlarms
    }

    func removePackageAlarms(alarm: AlarmModel) {
        packageAlarms.removeAll(where: { $0.id == alarm.id })
    }

    // MARK: - Monitoring Alarms

    func startMonitoringAlarms(alarms: [AlarmModel]) {
        self.alarms = alarms
    }

    func stopMonitoringAlarms() {
        timer?.invalidate()
        timer = nil
    }

    // MARK: - Alarm Actions

    func checkUserAwake(completionHandler: @escaping (_ isAwake: Bool) -> Void) {
        if isAwakeProgressing {
            return
        } else {
            isAwakeProgressing = true
        }

        guard let nearestActiveAlarm = nearestActiveAlarm else {
            isAwakeProgressing = false
            return
        }
        if nearestActiveAlarm.isTriggered {
            isAwakeProgressing = false
            return
        }

        if nearestActiveAlarm.sensors == [false, false] {
//            dump(nearestActiveAlarm)
            isAwake = false
            isAwakeProgressing = false
            completionHandler(false)
            return
        }

        awakeStateDidChange = { [weak self] isAwake in
            if isAwake {
                self?.isAwakeProgressing = false
                completionHandler(true)
                self?.awakeStateDidChange = nil // stop observing after awake
            }
        }

        let awakeDetectionService = AwakeDetectionService(sensor: nearestActiveAlarm.sensors)

        if nearestActiveAlarm.sensors == [true, true] {
            sleepViewModelSensorText = "Gyroscope and Accelerometer Scanning"
        } else if nearestActiveAlarm.sensors[0] == true {
            sleepViewModelSensorText = "Gyroscope Scanning"
        } else {
            sleepViewModelSensorText = "Accelerometer Scanning"
        }

        // Schedule a check in 60 seconds if user is not awake till then
        DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
            self.isAwake = awakeDetectionService.isAwake
            if self.isAwake == false {
                self.sleepViewModelSensorText = ""
                self.isAwakeProgressing = false
                completionHandler(false)
            } else if self.isAwake == true {
                self.sleepViewModelSensorText = ""
                self.isAwakeProgressing = false
                completionHandler(true)
            }

            self.awakeStateDidChange = nil // remove observer after the check
        }
    }

    func fireAlarm(alarm: AlarmModel) {
        guard lastTriggeredAlarm != alarm else {
            return
        }
        lastTriggeredAlarm = alarm
        
        let center = UNUserNotificationCenter.current()

        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Yay! We have the permission to send push notifications!")
            } else {
                print("D'oh")
            }
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Wake up!"
        content.body = "It's time to wake up."
//        content.sound = UNNotificationSound(named: UNNotificationSoundName(alarm.tone))
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "TimeToWakeUp.caf"))

        if alarm.vibrate == .on {
            content.sound = UNNotificationSound.defaultCriticalSound(withAudioVolume: 1.0)
        }
        
        
        //
        let audio = AudioViewModel()
        audio.setVolumeLeve(volume: Float(alarm.volume) / 100)
        audio.playSound(sound: alarm.tone, type: "caf")
        
        let haptic = HapticsService.shared
        haptic.startHaptics()
        
        let alert = UIAlertController(title: "Wake up!", message: "It's time to wake up.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            audio.stopSound()
            haptic.stopHaptics()
            if alarm.recurringDays.isEmpty {
                let updatedAlarm = alarm
                updatedAlarm.active = .inactive
                DatabaseService.shared.editAlarm(alarm: updatedAlarm)
            }
            
        }))
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootViewController = window.rootViewController {
            rootViewController.present(alert, animated: true)
            
        }
        
        //
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "alarm", content: content, trigger: trigger)
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error: \(error)")
            }
        }
        
        if alarm.recurringDays.isEmpty {
            var updatedAlarm = alarm
            updatedAlarm.active = .inactive
            DatabaseService.shared.editAlarm(alarm: updatedAlarm)
        }
    }

    // MARK: - Check Nearest Active Alarm

    func checkNearestActiveAlarm() {
        let alarms = DatabaseService.shared.fetchAlarms()
        var nearestActiveAlarm: AlarmModel?
        let now = Date()
        let calendar = Calendar.current
        let nowTime = now.timeIntervalSince1970

        var timestampAndAlarms = [TimestampAndAlarm]()

        for alarm in alarms {
            if alarm.active == .active {
                // Check if the alarm should be active on the current day
                var alarmTimeComponents = DateComponents()
                alarmTimeComponents.hour = Int(alarm.hour)
                alarmTimeComponents.minute = Int(alarm.minute)
                let nowComponents = calendar.dateComponents([.year, .month, .day], from: now)
                alarmTimeComponents.year = nowComponents.year
                alarmTimeComponents.month = nowComponents.month
                alarmTimeComponents.day = nowComponents.day
                guard let alarmTime = calendar.date(from: alarmTimeComponents) else {
                    print("Error: Could not create alarm time")
                    return
                }
                var alarmTimestamp = alarmTime.timeIntervalSince1970
                if alarmTimestamp < nowTime {
                    alarmTimestamp += 86400
                }
                let date = Date(timeIntervalSince1970: alarmTimestamp)
                let calendar = Calendar.current
                let components = calendar.dateComponents([.day], from: date)

                var day = components.day!
                if day >= 6 {
                    day = 0
                } else {
                    day += 1
                }
                let currentDay = Constants.daysOfWeek[day]
                if !alarm.recurringDays.isEmpty && !alarm.recurringDays.contains(currentDay) {
                    continue
                }
                timestampAndAlarms.append(TimestampAndAlarm(timestamp: alarmTimestamp, alarm: alarm))
            }
        }

        if let nearest = timestampAndAlarms.min(by: { $0.timestamp < $1.timestamp }) {
            nearestActiveAlarm = nearest.alarm
        }

        self.nearestActiveAlarm = nearestActiveAlarm
    }
}
