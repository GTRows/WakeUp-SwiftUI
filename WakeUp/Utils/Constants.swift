//
//  Constants.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu on 4.06.2023.
//

import Foundation

struct Constants {
    public static var currentUser = UserModel(id: "", name: "", email: "", avatar: "")
    public static var errrorUser = UserModel(id: "error", name: "error", email: "error", avatar: "error")
    
    static let tempPackages = [
        PackageModel(id: UUID(), name: "Test Package", image: "https://firebasestorage.googleapis.com:443/v0/b/wakeupapp-8a6b0.appspot.com/o/Avatars%2F859C1E56-FC38-4BD2-BE37-FE79DB7D88E5.jpg?alt=media&token=96b78ec3-3d13-45c1-9236-0286e7cc8e7e", description: "Bu view test için tasalarnmış bir package'dır içi boştur kesinlikle yerseniz basınca büyür.", Creator: UserModel(id: "1", name: "Fatih", email: "aciroglu.fatih@gmail.com", avatar: "https://firebasestorage.googleapis.com:443/v0/b/wakeupapp-8a6b0.appspot.com/o/Avatars%2F859C1E56-FC38-4BD2-BE37-FE79DB7D88E5.jpg?alt=media&token=96b78ec3-3d13-45c1-9236-0286e7cc8e7e"), alarms: [AlarmModel(),AlarmModel(),AlarmModel()]),
        PackageModel(id: UUID(), name: "Test Package", image: "https://firebasestorage.googleapis.com:443/v0/b/wakeupapp-8a6b0.appspot.com/o/Avatars%2F859C1E56-FC38-4BD2-BE37-FE79DB7D88E5.jpg?alt=media&token=96b78ec3-3d13-45c1-9236-0286e7cc8e7e", description: "Bu view test için tasalarnmış bir package'dır içi boştur kesinlikle yerseniz basınca büyür.", Creator: UserModel(id: "1", name: "Fatih", email: "aciroglu.fatih@gmail.com", avatar: "https://firebasestorage.googleapis.com:443/v0/b/wakeupapp-8a6b0.appspot.com/o/Avatars%2F859C1E56-FC38-4BD2-BE37-FE79DB7D88E5.jpg?alt=media&token=96b78ec3-3d13-45c1-9236-0286e7cc8e7e"), alarms: [AlarmModel(),AlarmModel(),AlarmModel()]),
        PackageModel(id: UUID(), name: "Test Package", image: "https://firebasestorage.googleapis.com:443/v0/b/wakeupapp-8a6b0.appspot.com/o/Avatars%2F859C1E56-FC38-4BD2-BE37-FE79DB7D88E5.jpg?alt=media&token=96b78ec3-3d13-45c1-9236-0286e7cc8e7e", description: "Bu view test için tasalarnmış bir package'dır içi boştur kesinlikle yerseniz basınca büyür.", Creator: UserModel(id: "1", name: "Fatih", email: "aciroglu.fatih@gmail.com", avatar: "https://firebasestorage.googleapis.com:443/v0/b/wakeupapp-8a6b0.appspot.com/o/Avatars%2F859C1E56-FC38-4BD2-BE37-FE79DB7D88E5.jpg?alt=media&token=96b78ec3-3d13-45c1-9236-0286e7cc8e7e"), alarms: [AlarmModel(),AlarmModel(),AlarmModel()]),
        PackageModel(id: UUID(), name: "Test Package", image: "https://firebasestorage.googleapis.com:443/v0/b/wakeupapp-8a6b0.appspot.com/o/Avatars%2F859C1E56-FC38-4BD2-BE37-FE79DB7D88E5.jpg?alt=media&token=96b78ec3-3d13-45c1-9236-0286e7cc8e7e", description: "Bu view test için tasalarnmış bir package'dır içi boştur kesinlikle yerseniz basınca büyür.", Creator: UserModel(id: "1", name: "Fatih", email: "aciroglu.fatih@gmail.com", avatar: "https://firebasestorage.googleapis.com:443/v0/b/wakeupapp-8a6b0.appspot.com/o/Avatars%2F859C1E56-FC38-4BD2-BE37-FE79DB7D88E5.jpg?alt=media&token=96b78ec3-3d13-45c1-9236-0286e7cc8e7e"), alarms: [AlarmModel(),AlarmModel(),AlarmModel()]),
        PackageModel(id: UUID(), name: "Test Package", image: "https://firebasestorage.googleapis.com:443/v0/b/wakeupapp-8a6b0.appspot.com/o/Avatars%2F859C1E56-FC38-4BD2-BE37-FE79DB7D88E5.jpg?alt=media&token=96b78ec3-3d13-45c1-9236-0286e7cc8e7e", description: "Bu view test için tasalarnmış bir package'dır içi boştur kesinlikle yerseniz basınca büyür.", Creator: UserModel(id: "1", name: "Fatih", email: "aciroglu.fatih@gmail.com", avatar: "https://firebasestorage.googleapis.com:443/v0/b/wakeupapp-8a6b0.appspot.com/o/Avatars%2F859C1E56-FC38-4BD2-BE37-FE79DB7D88E5.jpg?alt=media&token=96b78ec3-3d13-45c1-9236-0286e7cc8e7e"), alarms: [AlarmModel(),AlarmModel(),AlarmModel()])
    ]
    
    static let daysOfWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

    enum MusicCategory: String, CaseIterable {
        case recommended = "Recommended"
        case mixes = "Mixes"
        case sleepTales = "SleepTales"
        case meditations = "Meditations"
        case natureSounds = "Nature Sounds"
        case whiteNoise = "White Noise"
        case classicalMusic = "Classical Music"
        case instrumentalMusic = "Instrumental Music"
        case rainAndThunderstorms = "Rain and Thunderstorms"
        case underwater = "Underwater"
        case medievalDream = "Medieval Dream"
        case machine = "Machine"
    }

    // other constants can go here

    // Temp Album Covers
    static let tempCovers = [
        "SoloCover.jpg",
        "PieceOfMindCover.jpeg",
        "PowerslaveCover.jpeg",
        "TheNumberOfTheBeastCover.jpeg",
        "MutterCover.jpg",
        "RammsteinCover.png",
    ]

    static let tempQuote = "Don't stop when you are tired STOP when you're DONE"

    // Temp MusicModels
    static let tempMusics = [
        MusicModel(id: UUID(), name: "Solo", category: .recommended, duration: 180, coverName: "SoloCover", isPlaying: false, isLooping: false),
        MusicModel(id: UUID(), name: "Piece of Mind", category: .recommended, duration: 180, coverName: "PieceOfMindCover", isPlaying: false, isLooping: false),
        MusicModel(id: UUID(), name: "Powerslave", category: .recommended, duration: 180, coverName: "PowerslaveCover", isPlaying: false, isLooping: false),
        MusicModel(id: UUID(), name: "The Number of The Beast", category: .recommended, duration: 180, coverName: "TheNumberOfTheBeastCover", isPlaying: false, isLooping: false),
        MusicModel(id: UUID(), name: "Mutter", category: .recommended, duration: 180, coverName: "MutterCover", isPlaying: false, isLooping: false),
        MusicModel(id: UUID(), name: "Rammstein", category: .recommended, duration: 180, coverName: "RammsteinCover", isPlaying: false, isLooping: false),
    ]

    // Temp Articles
    static let tempArticles = [
        // Örnek verilerin oluşturulması
        ArticlesModel(id: UUID(),
                      title: "Unplug before bed",
                      description: "Unplugging from smartphones and laptops about 30 minutes before bed can contribute to a better night of sleep.",
                      image: "Article1",
                      url: "https://example.com/article1"),

        ArticlesModel(id: UUID(),
                      title: "The Benefits of Meditation",
                      description: "Meditation has been shown to reduce stress, improve focus, and promote emotional well-being.",
                      image: "Article2",
                      url: "https://example.com/article2"),

        ArticlesModel(id: UUID(),
                      title: "Healthy Eating Habits",
                      description: "Eating a balanced diet rich in fruits, vegetables, and whole grains is essential for maintaining good health.",
                      image: "Article3",
                      url: "https://example.com/article3"),
        ArticlesModel(id: UUID(), title: "The 7 Best Sleep Apps of 2021", description: "The 7 Best Sleep Apps of 2021", image: "Article4", url: "https://www.healthline.com/health/healthy-sleep/best-sleep-apps"),
    ]

    func getRandomGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())

        if hour < 12 {
            let morningGreetings = [
                "Good morning!",
                "Have a wonderful morning!",
                "Rise and shine!",
            ]
            let randomIndex = Int.random(in: 0 ..< morningGreetings.count)
            return morningGreetings[randomIndex]
        } else if hour < 18 {
            let afternoonGreetings = [
                "Good afternoon!",
                "Hope you're having a great day!",
                "Enjoy the afternoon!",
            ]
            let randomIndex = Int.random(in: 0 ..< afternoonGreetings.count)
            return afternoonGreetings[randomIndex]
        } else {
            let eveningGreetings = [
                "Good evening!",
                "Wishing you a pleasant evening!",
                "Hope you had a productive day!",
            ]
            let randomIndex = Int.random(in: 0 ..< eveningGreetings.count)
            return eveningGreetings[randomIndex]
        }
    }
}
