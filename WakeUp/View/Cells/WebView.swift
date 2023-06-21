//
//  WebView.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu on 21.06.2023.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let videoID: String

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let url = URL(string: "https://www.youtube.com/embed/\(videoID)") else {
            return
        }
        uiView.load(URLRequest(url: url))
    }
}


//struct WebView_Previews: PreviewProvider {
//    static var previews: some View {
//        WebView()
//    }
//}
