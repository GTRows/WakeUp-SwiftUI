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
    var visibility: Bool = false
    var Creator: UserModel
    var alarms: [AlarmModel]

    init(id: UUID, name: String, image: String, description: String, visibility: Bool, Creator: UserModel, alarms: [AlarmModel]) {
        self.id = id
        self.name = name
        self.image = image
        self.description = description
        self.visibility = visibility
        self.Creator = Creator
        self.alarms = alarms
    }

    func toDict() -> [String: Any] {
        return [
            "id": id.uuidString,
            "name": name,
            "image": image,
            "description": description,
            "visibility": visibility,
            "creator": Creator.toDict(),
            "creatorId": Creator.id,
            "alarms": alarms.map { $0.toDict() },
        ]
    }
}


extension PackageModel {
    init(from dict: [String: Any]) {
        id = UUID(uuidString: dict["id"] as? String ?? "") ?? UUID()
        name = dict["name"] as? String ?? "Default"
        image = dict["image"] as? String ?? ""
        description = dict["description"] as? String ?? ""
        visibility = dict["visibility"] as? Bool ?? false
        
        
        // Assuming UserModel and AlarmModel have their own `init(from:)` functions.
        Creator = UserModel(from: dict["creator"] as? [String: Any] ?? [:]) ?? UserModel(id: "", name: "Error", email: "", avatar: "")
        let alarmsData = dict["alarms"] as? [[String: Any]] ?? []
        alarms = alarmsData.compactMap { AlarmModel(from: $0) }
    }
}


