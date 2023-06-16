//
//  AlarmModel.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu on 11.04.2023.
//

import AVKit
import CoreData
import Foundation
import SwiftUI

enum AlarmActiveState: Int16 {
    case active = 1
    case inactive = 0
}

enum VibratingState: Int16 {
    case on = 1
    case off = 0
}

extension AlarmModel: Equatable {
    static func == (lhs: AlarmModel, rhs: AlarmModel) -> Bool {
        return lhs.id == rhs.id // Assuming that `id` uniquely identifies an alarm
    }
}

class AlarmModel: ObservableObject, ShareAbleCellProtocol {
    func getCellView() -> any View {
        AlarmCellView(alarm: self, mod: .show)
    }
    
    func getNameModel() -> String {
        return "Alarm"
    }
    
    func share(emailToShare: String, completion: @escaping (Result<Void, Error>) -> Void) {
        FireBaseService.shared.shareAlarm(self, withEmail: emailToShare) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    @Published var id: UUID
    @Published var name: String
    @Published var active: AlarmActiveState
    @Published var vibrate: VibratingState
    @Published var tone: String
    @Published var hour: Int
    @Published var minute: Int
    @Published var volume: Int
    @Published var tasks: [Bool] // math, memory, faceID
    @Published var sensors: [Bool] // Gyroscope, accelerometer
    @Published var recurringDays: [String]
    @Published var isTriggered: Bool = false

    init(from alarmCD: NSManagedObject) {
        let alarm = alarmCD as! Alarm
        id = alarm.id ?? UUID()
        name = alarm.name ?? ""
        active = AlarmActiveState(rawValue: alarm.active) ?? .active
        vibrate = VibratingState(rawValue: alarm.vibrate) ?? .on
        tone = alarm.tone ?? ""
        hour = Int(alarm.hour)
        minute = Int(alarm.minute)
        volume = Int(alarm.volume)
        tasks = alarm.tasks as? [Bool] ?? [false, false, false]
        sensors = alarm.sensors as? [Bool] ?? [false, false]
        recurringDays = alarm.recurringDays as? [String] ?? []
    }

    init(from dict: [String: Any]) {
        id = UUID(uuidString: dict["id"] as? String ?? "") ?? UUID()
        name = dict["name"] as? String ?? "Default"
        active = AlarmActiveState(rawValue: dict["active"] as? Int16 ?? 1) ?? .active
        vibrate = VibratingState(rawValue: dict["vibrate"] as? Int16 ?? 1) ?? .on
        tone = dict["tone"] as? String ?? ""
        hour = dict["hour"] as? Int ?? 0
        minute = dict["minute"] as? Int ?? 0
        volume = dict["volume"] as? Int ?? 0
        tasks = dict["tasks"] as? [Bool] ?? [false, false, false]
        sensors = dict["sensors"] as? [Bool] ?? [false, false]
        recurringDays = dict["recurringDays"] as? [String] ?? []
    }

    init(name: String, active: AlarmActiveState, vibrate: VibratingState, tone: String, hour: Int, minute: Int, volume: Int, tasks: [Bool], sensors: [Bool], recurringDays: [String]) {
        id = UUID()
        self.name = name
        self.active = active
        self.vibrate = vibrate
        self.tone = tone
        self.hour = hour
        self.minute = minute
        self.volume = volume
        self.tasks = tasks
        self.sensors = sensors
        self.recurringDays = recurringDays
    }

    init() {
        id = UUID()
        name = "Yeni Alarm"
        tone = "NewMorningAlarm"
        active = .active
        vibrate = .on
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: currentDate)
        hour = components.hour ?? 0
        minute = components.minute ?? 0
        volume = Int(AVAudioSession.sharedInstance().outputVolume * 100)
        tasks = [false, false, false]
        sensors = [false, false]
        recurringDays = []
    }

    func toDict() -> [String: Any] {
        return [
            "id": id.uuidString,
            "name": name,
            "active": active.rawValue,
            "vibrate": vibrate.rawValue,
            "tone": tone,
            "hour": hour,
            "minute": minute,
            "volume": volume,
            "tasks": tasks,
            "sensors": sensors,
            "recurringDays": recurringDays,
        ]
    }
}
