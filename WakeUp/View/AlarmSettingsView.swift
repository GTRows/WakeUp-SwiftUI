//
//  AlarmSettingsView.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu
//
import AVKit
import Foundation
import MediaPlayer
import SwiftUI

struct AlarmSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    @State private var wakeUpTime = Date()
    @State private var volumeLevel: Float = 0.5
    @State private var vibrateState = true
    @State private var previewState = false

    @ObservedObject var alarmViewModel: AlarmSettingsViewModel
    @ObservedObject var alarm: AlarmModel
    let Music = AudioViewModel()
    var action: AlarmAction

    init(alarm: AlarmModel, action: AlarmAction) {
        _alarm = ObservedObject(initialValue: alarm)
        self.action = action
        alarmViewModel = AlarmSettingsViewModel(alarm: alarm)
    }

    var body: some View {
        NavigationView {
            VStack {
                TextField("Alarm Name", text: $alarm.name)
                    .padding(.top)
                    .font(.title)
                    .multilineTextAlignment(.center)

                Text("Select Wake-Up Time:")
                    .font(.headline)
                    .padding()

                HStack {
                    Spacer()
                    DatePicker("", selection: $wakeUpTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.wheel)
                        .onAppear {
                            let calendar = Calendar.current
                            var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: wakeUpTime)
                            components.hour = alarm.hour
                            components.minute = alarm.minute

                            if let updatedWakeUpTime = calendar.date(from: components) {
                                wakeUpTime = updatedWakeUpTime
                            }
                        }
                    Spacer()
                }

                HStack {
                    Text("Repeat on:")
                        .padding(.leading)
                    Spacer()
                }

                HStack {
                    ForEach(0 ..< 7) { index in
                        Button(action: {
                            toggleRepeatDay(index)
                        }) {
                            Text(Constants.daysOfWeek[index])
                                .frame(width: 40)
                                .font(.subheadline)
                                .foregroundColor(alarm.recurringDays.contains(Constants.daysOfWeek[index]) ? .black : .black)
                                .padding(.horizontal, 3)
                                .padding(.vertical, 10)
                                .background(alarm.recurringDays.contains(Constants.daysOfWeek[index]) ? Color.blue : Color.gray)
                                .cornerRadius(7)
                        }
                    }
                }
                .padding(.horizontal)

                HStack {
                    Text("Vibrate:")
                        .padding(.leading)
                    Spacer()
                    Toggle("", isOn: $vibrateState)
                        .toggleStyle(SwitchToggleStyle(tint: Color("Orange")))
                        .onChange(of: vibrateState) { newValue in
                            self.vibrateState = newValue
                        }.padding(.horizontal)
                }
                .padding(.vertical)

                HStack {
                    Text("Volume Level: \(Int(volumeLevel * 100))%")
                        .padding(.leading)
                        .padding(.top)
                    Spacer()
                }.onAppear {
                    self.volumeLevel = Float(alarm.volume) / 100
                    if self.previewState {
                        MPVolumeView.setVolume(Float(volumeLevel))
                    }
                }

                Slider(value: $volumeLevel, in: 0 ... 1, step: 0.1)
                    .padding(.horizontal)
                    .accentColor(Color("Orange"))
                    .onChange(of: volumeLevel) { newValue in
                        self.volumeLevel = newValue
                    }
                Spacer()

                VStack {
                    Button(action: {
                        if !self.Music.isPlaying && !self.previewState {
                            self.previewState = true
                            if self.vibrateState {
                                HapticsService.shared.startHaptics()
                            }
                            MPVolumeView.setVolume(Float(volumeLevel))
                            self.Music.playSound(sound: "NewMorningAlarm", type: "mp3")
//                            previewAlarm()
                            alarmViewModel.previewAlarm()

                        } else {
                            self.previewState = false
                            self.Music.pauseSound()
                            HapticsService.shared.prepareHaptics()
                        }
                    }) {
                        Text("preview alarm")
                            .foregroundColor(Color("Orange"))
                    }

                    Button(action: {
                        alarmViewModel.setAlarm(volumeLevel: volumeLevel, action: action, wakeUpTime: wakeUpTime)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        ContainerRelativeShape()
                            .fill(Color("Orange"))
                            .frame(height: 50)
                            .cornerRadius(10)
                            .overlay(
                                Text("Set Alarm")
                                    .foregroundColor(.white)
                            )
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.bottom, 100)
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
    
    func toggleRepeatDay(_ dayIndex: Int) {
        print("dayIndex: \(dayIndex)")
        guard dayIndex >= 0 && dayIndex < Constants.daysOfWeek.count else { return } // Check for valid index
        let day = Constants.daysOfWeek[dayIndex]
        if let index = alarm.recurringDays.firstIndex(of: day) {
            print("index: \(index)")
            alarm.recurringDays.remove(at: index)
            print("alarm.recurringDays: \(alarm.recurringDays)")
        } else {
            print("day: \(day)")
            alarm.recurringDays.append(day)
            print("alarm.recurringDays: \(alarm.recurringDays)")
        }
    }
}

struct AlarmSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmSettingsView(alarm: AlarmModel(), action: AlarmAction.add)
    }
}
