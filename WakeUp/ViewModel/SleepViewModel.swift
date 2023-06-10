//
//  SleepViewModel.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu on 4.06.2023.
//

import Foundation

class SleepViewModel: ObservableObject {
    @Published var isHaveAlarm: Bool = false
    @Published var selectedCategory: Constants.MusicCategory? = nil
    @Published var musics: [MusicModel] = Constants.tempMusics
    @Published var nearestActiveAlarm: AlarmModel?
    @Published var alarmTimeString: String = ""
    @Published var currentTime: String = ""
    private var timer: Timer?
    private var timer2: Timer?

    init() {
        updateCurrentTime()
        AlarmService.shared.checkNearestActiveAlarm()
        if let alarm = AlarmService.shared.nearestActiveAlarm {
            alarmTimeString = String(format: "%02d:%02d", alarm.hour, alarm.minute)
            nearestActiveAlarm = alarm
            isHaveAlarm = true
        } else {
            alarmTimeString = "NoneX"
            isHaveAlarm = false
        }
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.updateCurrentTime()
            self.checkAlarm()
        }
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
                // If the times match, fire the alarm and update the nearest active alarm
                AlarmService.shared.fireAlarm(alarm: alarm)
                nearestActiveAlarm?.isTriggered = true
                if let newAlarm = AlarmService.shared.nearestActiveAlarm {
                    nearestActiveAlarm = newAlarm
                    alarmTimeString = String(format: "%02d:%02d", newAlarm.hour, newAlarm.minute)
                } else {
                    alarmTimeString = "None"
                    nearestActiveAlarm = nil
                    isHaveAlarm = false
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
