//
//  ImageStorageService.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu on 11.06.2023.
//

import UIKit

class ImageStorageService {
    
    static let shared = ImageStorageService()
    
    private let fileManager: FileManager
    private let documentDirectoryURL: URL
    
    private init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Unable to access document directory")
        }
        self.documentDirectoryURL = url
    }
    
    func store(image: UIImage, for key: String) {
        guard let imageData = image.jpegData(compressionQuality: 1) else {
            print("Could not convert image to data.")
            return
        }
        let filePath = self.documentDirectoryURL.appendingPathComponent(key)
        do {
            try imageData.write(to: filePath)
            print("Successfully stored image.")
        } catch {
            print("Could not store image: \(error).")
        }
    }
    
    func retrieveImage(for key: String) -> UIImage? {
        let filePath = self.documentDirectoryURL.appendingPathComponent(key)
        do {
            let imageData = try Data(contentsOf: filePath)
            return UIImage(data: imageData)
        } catch {
            print("Could not retrieve image: \(error).")
            return nil
        }
    }
}
