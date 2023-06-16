//
//  SleepView.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu on 4.06.2023.
//

import SwiftUI

struct SleepView: View {
    @ObservedObject private var viewModel = SleepViewModel()
    @State private var isHaveAlarm = true
    @State private var selectedCategory: String?

    var body: some View {
        VStack {
            Text(viewModel.currentTime)
                .font(.system(size: 50))
                .fontWeight(.bold)
                .padding(.top, 100)

            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.white)
                    .frame(width: 150, height: 50)
                    .shadow(radius: 10)
                HStack {
                    Image(systemName: "alarm")
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                    Spacer()
                Text(viewModel.alarmTimeString)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    
                }
                .frame(width: 100, height: 50)
            }
            // Music Category horizontal scroll
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(Constants.MusicCategory.allCases, id: \.self) { item in
                        ZStack(alignment: .bottom) {
                            // Button category
                            Button(action: {
                                selectedCategory = item.rawValue
                            }) {
                                ZStack {
                                    Text(item.rawValue)
                                        .font(.system(size: 20))
                                        .foregroundColor(.white)
                                }
                            }
                            GeometryReader { geometry in
                                Capsule()
                                    .fill(selectedCategory == item.rawValue ? Color.blue : Color.clear)
                                    .frame(width: geometry.size.width - 10, height: 2)
                            }
                            .frame(height: 2, alignment: .bottom)
                        }
                        .onTapGesture {
                            selectedCategory = item.rawValue
                        }
                    }
                }
            }
            .padding(.top, 100)
            // Music List

            ScrollView(.horizontal) {
                HStack {
                    ForEach(Constants.tempMusics, id: \.id) { item in
                        MusicCellView(music: item)
                            .frame(maxWidth: 400)
                    }
                }
            }.padding(.top, 20)
                .padding(.bottom)
            Text(AlarmService.shared.sleepViewModelSensorText)
                .padding()
            Spacer()
        }.onAppear(){
            viewModel.checkAlarm()
        }
    }
}

struct SleepView_Previews: PreviewProvider {
    static var previews: some View {
        SleepView()
    }
}
