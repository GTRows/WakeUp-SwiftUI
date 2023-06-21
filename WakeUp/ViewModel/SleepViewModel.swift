//
//  SleepViewModel.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu on 4.06.2023.
//

import Foundation
import UIKit

class SleepViewModel: ObservableObject {
    @Published var isHaveAlarm: Bool = false
    @Published var selectedCategory: Constants.MusicCategory? = nil
    @Published var musics: [MusicModel] = []
    @Published var nearestActiveAlarm: AlarmModel?
    @Published var alarmTimeString: String = ""
    @Published var currentTime: String = ""
    @Published var wakeLock: Bool = false

    private var timer: Timer?
    private var timer2: Timer?
    private var musicsData: [MusicModel] = []

    init() {
        updateCurrentTime()
        AlarmService.shared.checkNearestActiveAlarm()
        if let alarm = AlarmService.shared.nearestActiveAlarm {
//            AlertService.shared.showString(title: "", message: "Please connect your device to the charger to use this feature.")
            alarmTimeString = String(format: "%02d:%02d", alarm.hour, alarm.minute)
            nearestActiveAlarm = alarm
            isHaveAlarm = true
        } else {
            alarmTimeString = "NoneX"
            isHaveAlarm = false
        }
        FireBaseService.shared.fetchMusics { Result in
            switch Result {
            case let .success(musics):
                self.musicsData = musics
                self.getMusics(category: .recommended)
            case let .failure(error):
                AlertService.shared.show(error: error)
            }
        }
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.updateCurrentTime()
            self.checkAlarm()
        }
    }

    public func getMusics(category: MusicCategory) {
        musics = musicsData.filter({ $0.category == category })
    }

    private func updateCurrentTime() {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        currentTime = formatter.string(from: now)
    }

    public func checkAlarm() {
        let now = Date()
        let calendar = Calendar.current
        let currentTime = calendar.dateComponents([.hour, .minute], from: now)

        // Compare the current time with the nearest active alarm's time
        if let alarm = nearestActiveAlarm {
            let alarmTime = DateComponents(hour: Int(alarm.hour), minute: Int(alarm.minute))
            if currentTime == alarmTime && alarm.isTriggered == false {
                // Check if user is awake
                AlarmService.shared.checkUserAwake { isAwake in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        if isAwake {
                            print("User awake")
                            print("Skipped alarm")
                        } else {
                            // If the times match, fire the alarm and update the nearest active alarm
                            AlarmService.shared.fireAlarm(alarm: alarm)
                            self.nearestActiveAlarm?.isTriggered = true
                            if let newAlarm = AlarmService.shared.nearestActiveAlarm {
                                self.nearestActiveAlarm = newAlarm
                                self.alarmTimeString = String(format: "%02d:%02d", newAlarm.hour, newAlarm.minute)
                            } else {
                                self.alarmTimeString = "None"
                                self.nearestActiveAlarm = nil
                                self.isHaveAlarm = false
                            }
                        }
                    }
                }
            }
        } else {
            // If there's no nearest active alarm, try to get a new one
            if let newAlarm = AlarmService.shared.nearestActiveAlarm {
                nearestActiveAlarm = newAlarm
                alarmTimeString = String(format: "%02d:%02d", newAlarm.hour, newAlarm.minute)
                isHaveAlarm = true
            }
        }
    }
}
