//
//  ProfileViewModel.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu on 15.06.2023.
//

import Foundation
import UIKit

class ProfileViewModel: ObservableObject {
    @Published var avatarImage: UIImage?

    init() {
        loadAvatar()
    }

    func loadAvatar() {
        FireBaseService.shared.getAvatar { image in
            DispatchQueue.main.async {
                self.avatarImage = image
            }
        }
    }
}
