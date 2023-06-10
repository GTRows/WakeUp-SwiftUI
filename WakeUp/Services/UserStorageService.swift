//
//  UserStorageService.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu on 10.06.2023.
//

import Foundation

class UserStorageService {
    static let shared = UserStorageService()

    private let userDefaults: UserDefaults
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init(userDefaults: UserDefaults = .standard,
         encoder: JSONEncoder = JSONEncoder(),
         decoder: JSONDecoder = JSONDecoder()) {
        self.userDefaults = userDefaults
        self.encoder = encoder
        self.decoder = decoder
    }

    func saveUser(user: UserModel) {
        do {
            let userData = try encoder.encode(user)
            userDefaults.set(userData, forKey: "user")
        } catch {
            print("Failed to save user: \(error)")
        }
    }

    func fetchUser() -> UserModel {
        guard let savedUserData = userDefaults.data(forKey: "user") else {
            print("Failed to fetch user")
            return Constants.errrorUser
        }
        do {
            let user = try decoder.decode(UserModel.self, from: savedUserData)
            return user
        } catch {
            print("Failed to decode user: \(error)")
            return Constants.errrorUser
        }
    }
}
