//
//  MusicModel.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu on 4.06.2023.
//

import Foundation

struct MusicModel{
    var id: UUID
    var name: String
    var category: Constants.MusicCategory
    var duration: Int
    var coverName: String
    var isPlaying: Bool
    var isLooping: Bool
}
