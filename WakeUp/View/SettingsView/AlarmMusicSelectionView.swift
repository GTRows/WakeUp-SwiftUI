//
//  AlarmMusicSelectionView.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu on 14.06.2023.
//

import SwiftUI

struct AlarmMusicSelectionView: View {
    @Binding var selectedMusic: String?
    let musicList = ["2PAC - Legendary2", "Avicii - WakeMeUp", "Courage to tell a lie", "Hayko Cepkin-Hayvaaa1n", "NewMorningAlarm", "NOAPOLOGY-Deadhearted", "TimeToWakeUp", "WAKE UP"]
    
    var body: some View {
        NavigationView {
            List(musicList, id: \.self) { music in
                HStack {
                    Text(music)
                    Spacer()
                    if music == selectedMusic {
                        Image(systemName: "checkmark").foregroundColor(.blue)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedMusic = music
                }
            }
            .navigationTitle("Alarm Müzik Seçimi")
        }
    }
}
