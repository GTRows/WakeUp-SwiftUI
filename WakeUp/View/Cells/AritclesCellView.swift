//
//  AritclesCellView.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu on 6.06.2023.
//

import SafariServices
import SwiftUI

struct AritclesCellView: View {
    var article: ArticlesModel
    @State private var showSafari = false
    @ObservedObject private var loader: ImageLoader
    
    init(article: ArticlesModel) {
        self.article = article
        self.loader = ImageLoader()
        loader.load(url: article.image)
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Image(uiImage: loader.image ?? UIImage(named: "Article1")!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width - 60, height: 150)
                    .clipped()
                    .cornerRadius(20)
                    .padding(.leading, 20)
                
                Text(article.title)
                    .font(.largeTitle)
                    .frame(width: UIScreen.main.bounds.width - 60, alignment: .leading)
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 1)
                Text(article.description)
                    .font(.subheadline)
                    .frame(width: UIScreen.main.bounds.width - 60, alignment: .leading)
                    .padding(.horizontal, 20)
                Button(action: {
                    // url = article.url
                    showSafari = true
                }) {
                    Text("Read More")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width - 60, height: 50)
                        .background(Color("Orange"))
                        .cornerRadius(20)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                }
            }
            .padding(.vertical)
            .background(Color("DarkGray"))
            .cornerRadius(20)
            .sheet(isPresented: $showSafari) {
                if let url = URL(string: article.url) {
                    SafariView(url: url)
                }
            }
        }
    }
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> some UIViewController {
        let safariVC = SFSafariViewController(url: url)
        return safariVC
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

struct AritclesCellView_Previews: PreviewProvider {
    static var previews: some View {
        AritclesCellView(article: ArticlesModel(from: [:]))
    }
}
