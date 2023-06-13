//
//  PackageModel.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu on 9.06.2023.
//

import Foundation

struct PackageModel: Identifiable {
    var id: UUID
    var name: String
    var image: String
    var description: String
    var Creator: UserModel
    var alarms: [AlarmModel]

    init(id: UUID, name: String, image: String, description: String, Creator: UserModel, alarms: [AlarmModel]) {
        self.id = id
        self.name = name
        self.image = image
        self.description = description
        self.Creator = Creator
        self.alarms = alarms
    }

    func toDict() -> [String: Any] {
        return [
            "id": id.uuidString,
            "name": name,
            "image": image,
            "description": description,
            "creator": Creator.toDict(), // assumes UserModel has a toDict function
            "alarms": alarms.map { $0.toDict() }, // assumes AlarmModel has a toDict function
        ]
    }
}
