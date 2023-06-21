//
//  MusicModel.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu on 4.06.2023.
//

import Foundation


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

struct MusicModel{
    var id: UUID
    var name: String
    var key: String
    var category: MusicCategory
    
    func toDict() -> [String: Any] {
            return [
                "id": id.uuidString,
                "name": name,
                "key": key,
                "category": category.rawValue
            ]
        }
    
}
