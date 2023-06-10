//
//  MusicCellView.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu on 4.06.2023.
//

import SwiftUI

struct MusicCellView: View {
    @State var music: MusicModel

    var body: some View {
        ZStack {
            Image(music.coverName) // Şarkı kapak resmi adını buraya yazın
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 25, maxWidth: .infinity, minHeight: 0, maxHeight: 200)
                .cornerRadius(10)
                .shadow(radius: 4)
            VStack {
                HStack{
                    Text("\(music.duration) min")
                        .font(.subheadline)
                        .foregroundColor(.red)
                        .shadow(radius: 100)
                    Spacer()
                    Button(action: {
                        music.isLooping.toggle()
                    }) {
                        Image(systemName: music.isLooping ? "repeat" : "repeat")
                            .font(.system(size: 24))
                            .foregroundColor(music.isLooping ? .green : .gray)
                            .shadow(radius: 100)
                    }
                    .padding(.trailing)
                }
                
                Button(action: {
                    music.isPlaying.toggle()
                }) {
                    Image(systemName: music.isPlaying ? "pause.circle" : "play.circle")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                }
                HStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.gray)
                            .opacity(0.8)
                            .frame(minWidth: 25, maxWidth: 200, minHeight: 0, maxHeight: 50)
                            .shadow(radius: 10)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(music.name)
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                            Text(music.category.rawValue)
                                .font(.subheadline)
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.leading, 2)
                    Spacer()
                }
                
            }
            .padding()
            .shadow(radius: 5)
        }
        .cornerRadius(50)
    }
}

struct MusicCellView_Previews: PreviewProvider {
    static var previews: some View {
        MusicCellView(music: Constants.tempMusics[0])
    }
}
