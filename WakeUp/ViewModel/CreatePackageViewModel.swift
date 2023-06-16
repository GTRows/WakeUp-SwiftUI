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
    @Published var description : String = ""
    var selectedAlarms: [AlarmModel] = []
    var package: PackageModel?

    func createPackage(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let image = image else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing image"])))
            return
        }

        // Upload image first
        let path = "Packages/\(UUID().uuidString)"
        FireBaseService.shared.uploadImage(image, path: path) { result in
            switch result {
            case .success(let imageUrl):
                // Image upload successful, create the package
                let package = PackageModel(id: UUID(), name: self.name, image: imageUrl, description: self.description, vizibility: self.vizibility, Creator: FireBaseService.shared.getUser(), alarms: AlarmService.shared.getPackageAlarms())
                FireBaseService.shared.addPackage(package: package) { result in
                    switch result {
                    case .success:
                        self.package = package
                        completion(.success(()))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

