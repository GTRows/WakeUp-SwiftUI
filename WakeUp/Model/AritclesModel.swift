//
//  AritclesModel.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu on 6.06.2023.
//

import Foundation

struct ArticlesModel: Identifiable, Codable {
    var id: UUID
    var title: String
    var description: String
    var image: String
    var url: String

    init(from dictionary: [String: Any]) {
        title = dictionary["title"] as? String ?? ""
        description = dictionary["description"] as? String ?? ""
        image = dictionary["image"] as? String ?? ""
        url = dictionary["url"] as? String ?? ""
        if let idString = dictionary["id"] as? String, let id = UUID(uuidString: idString) {
            self.id = id
        } else {
            id = UUID() // In case there is no id in the dictionary
        }
    }
}
