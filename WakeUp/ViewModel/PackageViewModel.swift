//
//  PackageViewModel.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu on 13.06.2023.
//

import Foundation
import UIKit

class PackageViewModel: ObservableObject {
    @Published var package: PackageModel
    @Published var image: UIImage?

    init(package: PackageModel) {
        self.package = package
        fetchImage()
    }

    private func fetchImage() {
        if image != nil {
            return
        }

        FireBaseService.shared.fetchImage(from: package.image) { image in
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }

    public func usePackage() {
        for alarm in package.alarms {
            DatabaseService.shared.addAlarm(alarm: alarm)
        }
    }
}
