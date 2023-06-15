//
//  ProfileSettingsViewModel.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu on 10.06.2023.
//

import Foundation
import UIKit

class ProfileSettingsViewModel: ObservableObject {
    @Published var image: UIImage?
    @Published var user: UserModel


    init(user: UserModel) {
        self.user = user
        self.loadAvatar()
    }
    
    
    func loadAvatar() {
        FireBaseService.shared.getAvatar { image in
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
    
    func editUser() {
        if let selectedImage = image {
            FireBaseService.shared.uploadImage(selectedImage, path: "Avatars") { result in
                switch result {
                case let .success(url):
                    print("Image successfully uploaded to \(url)")
                    var updatedUser = self.user
                    updatedUser.avatar = url
                    self.updateUser(user: updatedUser)
//                    self.imageStorageService.store(image: selectedImage, for: url)
                case let .failure(error):
                    print("Error uploading image: \(error)")
                    AlertService.shared.show(error: error)
                }
            }
            
        } else {
            updateUser(user: user)
        }
    }

    private func updateUser(user: UserModel) {
        FireBaseService.shared.updateUser(user: user) { result in
            switch result {
            case let .success(updatedUser):
                print("User successfully updated")
                self.user = updatedUser
            case let .failure(error):
                print("Error updating user: \(error)")
                AlertService.shared.show(error: error)
            }
        }
    }
}
