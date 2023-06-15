//
//  AlarmService.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu on 4.06.2023.
//

import Foundation
import SwiftUI
import UIKit

struct TimestampAndAlarm {
    let timestamp: Double
    let alarm: AlarmModel
}

final class AlarmService {
    private var awakeDetectionService: AwakeDetectionService?
    static let shared = AlarmService()
    @Published var nearestActiveAlarm: AlarmModel?
    private var alarms: [AlarmModel] = [] // alarm listesi
    private var timer: Timer?
    private var lastTriggeredAlarm: AlarmModel?

    private var packageAlarms: [AlarmModel] = []

    // Add an observer for the isAwake variable
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

        print("checkUserAwake called")
        guard let nearestActiveAlarm = nearestActiveAlarm else {
            isAwakeProgressing = false
            return
        }
        if nearestActiveAlarm.isTriggered {
            isAwakeProgressing = false
            return
        }

        if nearestActiveAlarm.sensors == [false, false] {
            dump(nearestActiveAlarm)
            isAwake = false
            print("No sensors selected")
            isAwakeProgressing = false
            completionHandler(false)
            return
        }

        awakeStateDidChange = { [weak self] isAwake in
            if isAwake {
                print("isAwake: \(isAwake)")
                self?.isAwakeProgressing = false
                completionHandler(true)
                self?.awakeStateDidChange = nil // stop observing after awake
            }
        }
        
        
        let awakeDetectionService = AwakeDetectionService(sensor: nearestActiveAlarm.sensors)

        // Schedule a check in 60 seconds if user is not awake till then
        DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
            self.isAwake = awakeDetectionService.isAwake
            if self.isAwake == false {
                print("isAwake: false")
                self.isAwakeProgressing = false
                completionHandler(false)
            } else if self.isAwake == true {
                print("isAwake: true")
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
        let alert = UIAlertController(title: "Wake up!", message: "It's time to wake up.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
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
