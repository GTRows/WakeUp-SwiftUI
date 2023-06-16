//
//  PackageModel.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu on 9.06.2023.
//

import Foundation
import SwiftUI

class PackageModel: Identifiable, ObservableObject, ShareAbleCellProtocol {
    func getCellView() -> any View {
        PackageCellView(package: self, mod: .show)
    }
    
    func share(emailToShare: String, completion: @escaping (Result<Void, Error>) -> Void) {
        FireBaseService.shared.sharePackage(self, withEmail: emailToShare) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    func getNameModel() -> String {
        return "Package"
    }

    var id: UUID
    var name: String
    var image: String
    var description: String
    var vizibility: Bool = false
    var Creator: UserModel
    var alarms: [AlarmModel]

    init(id: UUID, name: String, image: String, description: String, vizibility: Bool, Creator: UserModel, alarms: [AlarmModel]) {
        self.id = id
        self.name = name
        self.image = image
        self.description = description
        self.vizibility = vizibility
        self.Creator = Creator
        self.alarms = alarms
    }

    init(from dict: [String: Any]) {
        id = UUID(uuidString: dict["id"] as? String ?? "") ?? UUID()
        name = dict["name"] as? String ?? "Default"
        image = dict["image"] as? String ?? ""
        description = dict["description"] as? String ?? ""
        vizibility = dict["vizibility"] as? Bool ?? false

        // Assuming UserModel and AlarmModel have their own `init(from:)` functions.
        Creator = UserModel(from: dict["creator"] as? [String: Any] ?? [:]) ?? UserModel(id: "", name: "Error", email: "", avatar: "")
        let alarmsData = dict["alarms"] as? [[String: Any]] ?? []
        alarms = alarmsData.compactMap { AlarmModel(from: $0) }
    }

    func toDict() -> [String: Any] {
        return [
            "id": id.uuidString,
            "name": name,
            "image": image,
            "description": description,
            "vizibility": vizibility,
            "creator": Creator.toDict(),
            "creatorId": Creator.id,
            "alarms": alarms.map { $0.toDict() },
        ]
    }
}
