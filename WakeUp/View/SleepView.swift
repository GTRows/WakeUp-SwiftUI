//
//  SleepView.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu on 4.06.2023.
//

import Shimmer
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
                .onAppear {
                    UIDevice.current.isBatteryMonitoringEnabled = true
                }
                .onDisappear {
                    UIDevice.current.isBatteryMonitoringEnabled = false
                }

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
                    ForEach(MusicCategory.allCases, id: \.self) { item in
                        ZStack(alignment: .bottom) {
                            // Button category
                            Button(action: {
                                selectedCategory = item.rawValue
                                viewModel.getMusics(category: item)
                            }) {
                                Text(item.rawValue)
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
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
                    if viewModel.musics.isEmpty {
                        Text("No music found")
                            .frame(width: 350, height: 200)
                            .padding(.top, 15)
                            .shimmering()

                    } else {
                        ForEach(viewModel.musics, id: \.id) { item in
                            WebView(videoID: item.key)
                                .frame(width: 300, height: 200)
                                .padding(.top, 15)
                                .padding(.horizontal, 10)
                        }
                    }
                }
            }.padding(.top, 20)
                .padding(.bottom)

            Text(AlarmService.shared.sleepViewModelSensorText)
                .padding()
            Spacer()
        }.onAppear {
            viewModel.checkAlarm()
        }.onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            if self.viewModel.wakeLock {
                UIApplication.shared.isIdleTimerDisabled = true
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            if !self.viewModel.wakeLock {
                UIApplication.shared.isIdleTimerDisabled = false
            }
        }
    }
}

struct SleepView_Previews: PreviewProvider {
    static var previews: some View {
        SleepView()
    }
}
