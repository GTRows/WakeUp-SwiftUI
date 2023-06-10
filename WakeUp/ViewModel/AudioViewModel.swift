//
//  AudioModelView.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu
//

import Foundation
import AVKit

class AudioViewModel: ObservableObject {
    @Published var player: AVAudioPlayer!
    @Published var isPlaying = false
    
    func playSound(sound: String, type: String) {
        if let path = Bundle.main.path(forResource: sound, ofType: type) {
            do {
                player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                player.play()
                isPlaying = true
            } catch {
                print("Error playing sound: \(error)")
            }
        }
    }
    
    func stopSound() {
        player.stop()
        isPlaying = false
    }
    
    func pauseSound() {
        player.pause()
        isPlaying = false
    }
}

