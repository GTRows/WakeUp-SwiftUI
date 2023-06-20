//
//  ImageLoader.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu on 11.06.2023.
//

import SwiftUI
import Combine
import Foundation

class ImageLoader: ObservableObject {
    @Published var image: UIImage?

    private var cancellable: AnyCancellable?
    
    
    func load(url: String) {
        guard let imageURL = URL(string: url) else { return }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: imageURL)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }
    
    func cancel() {
        cancellable?.cancel()
    }
}

struct URLImage: View {
    @ObservedObject private var loader: ImageLoader
    
    init(url: String) {
        loader = ImageLoader()
        loader.load(url: url)
    }
    
    var body: some View {
        if let image = loader.image {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            ProgressView()
        }
    }
}

