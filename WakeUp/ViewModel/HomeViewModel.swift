//
//  HomeViewModel.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu on 5.06.2023.
//

import Foundation
import SwiftUI
import SwipeActions

class HomeViewModel: ObservableObject {
    @Published var userName = ""
    @Published var userAvatar = ""
    @Published var user: UserModel
    @Published var greetingMessage = ""
    @Published var quote = ""
    @Published var isHaveAlarm = false
    @Published var articles: [ArticlesModel] = []

    @Published var avatarImage: UIImage?

    var nearestActiveAlarm: AlarmModel = AlarmModel()

    init() {
        AlarmService.shared.checkNearestActiveAlarm()
        user = FireBaseService.shared.getUser()
        greetingMessage = Constants().getRandomGreeting()
        quote = Constants.tempQuote
        userName = user.name
        userAvatar = user.avatar
        loadAvatar()
        if let alarm = AlarmService.shared.nearestActiveAlarm {
            nearestActiveAlarm = alarm
            isHaveAlarm = true
        } else {
            isHaveAlarm = false
        }

        fetchArticles()

        fetchQuote { quote, _ in
            if let quote = quote {
                DispatchQueue.main.async {
                    self.quote = quote
                }
            }
        }
    }

    func loadAvatar() {
        FireBaseService.shared.getAvatar { image in
            DispatchQueue.main.async {
                self.avatarImage = image
            }
        }
    }

    func fetchQuote(completion: @escaping (String?, Error?) -> Void) {
        guard let url = URL(string: "https://zenquotes.io/api/today") else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(nil, error)
                return
            }

            guard let data = data else {
                completion(nil, NSError(domain: "Empty response data", code: 0, userInfo: nil))
                return
            }

            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]],
                   let quoteObject = jsonArray.first,
                   let quote = quoteObject["q"] as? String {
                    completion(quote, nil)
                } else {
                    completion(nil, NSError(domain: "Invalid response format", code: 0, userInfo: nil))
                }
            } catch {
                completion(nil, error)
            }
        }

        task.resume()
    }

    func fetchArticles() {
        FireBaseService.shared.fetchArticles { Result in
            switch Result {
            case let .success(articles):
                DispatchQueue.main.async {
                    self.articles = articles
                }
            case let .failure(error):
                AlertService.shared.show(error: error)
            }
        }
    }
}
