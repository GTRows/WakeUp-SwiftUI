//
//  CreatePackageViewModel.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu on 10.06.2023.
//

import Foundation
import UIKit

class CreatePackageViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var vizibility: Bool = false
    @Published var image: UIImage? = nil
    @Published var isCreatingPackage: Bool = false

    var package: PackageModel?

//    func createPackage() {
//        isCreatingPackage = true
//        // Assuming you have a UserModel instance named currentUser
//        let currentUser = UserModel() // This should be the currently logged in user
//        let alarms = [AlarmModel]() // This should be the alarms associated with the package
//        if let image = image, let jpegData = image.jpegData(compressionQuality: 0.1) {
//            package = PackageModel(id: UUID(), name: name, image: jpegData, Creator: currentUser, alarms: alarms)
//            
//            if let package = package {
//                FireBaseService.shared.createPackage(package) { result in
//                    switch result {
//                    case .success(let message):
//                        print(message)
//                        self.isCreatingPackage = false
//                    case .failure(let error):
//                        print("Error creating package: \(error)")
//                        self.isCreatingPackage = false
//                    }
//                }
//            }
//        }
//    }

}
