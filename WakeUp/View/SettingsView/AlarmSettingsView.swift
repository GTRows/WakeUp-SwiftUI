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

    @State private var isShowingSensors = false
    @State private var isShowingTasks = false

    let Music = AudioViewModel()
    var action: AlarmAction

    private let overlayRectangleWidth: CGFloat = CGFloat(UIScreen.main.bounds.width - 7)
    private var overlayRectangleView: some View {
        RoundedRectangle(cornerRadius: 20)
            .stroke(Color("Orange"), lineWidth: 2)
    }

    init(alarm: AlarmModel, action: AlarmAction) {
        _alarm = ObservedObject(initialValue: alarm)
        self.action = action
        alarmViewModel = AlarmSettingsViewModel(alarm: alarm)
    }

    var body: some View {
        NavigationView {
            VStack {
                // stick
                Rectangle()
                    .fill(.white)
                    .frame(width: 75, height: 5, alignment: .center)
                    .cornerRadius(100)
                    .padding(.top)

                // Select time
                Text("Alarm Settings View")
                    .padding(.top)
                    .font(.title)
                    .fontWeight(.light)
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
                ScrollView {
                    DatePicker("", selection: $wakeUpTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.wheel)
                        .frame(width: UIScreen.main.bounds.width - 100, alignment: .center)
                        .padding(.horizontal)
                        .onAppear {
                            let calendar = Calendar.current
                            var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: wakeUpTime)
                            components.hour = alarm.hour
                            components.minute = alarm.minute
                            if let updatedWakeUpTime = calendar.date(from: components) {
                                wakeUpTime = updatedWakeUpTime
                            }
                        }
                    // conf view
                    VStack {
                        // name area
                        HStack {
                            Text("Name")

                            TextField("Alarm Name", text: $alarm.name)
                                .font(.title)
                                .frame(width: UIScreen.main.bounds.width - 100)
                                .multilineTextAlignment(.center)
                        }
                        .frame(height: 50)
                        .overlay(
                            overlayRectangleView
                                .frame(width: overlayRectangleWidth)
                        )
                        .padding(.vertical, 5)

                        // Vibrate area
                        HStack {
                            Text("Vibrate")
                                .padding(.leading, 28)
                            Spacer()
                            Toggle("", isOn: $vibrateState)
                                .toggleStyle(SwitchToggleStyle(tint: Color("Orange")))
                                .onChange(of: vibrateState) { newValue in
                                    self.vibrateState = newValue
                                }
                                .padding(.horizontal, 28)
                        }.frame(height: 50)
                            .overlay(
                                overlayRectangleView
                                    .frame(width: overlayRectangleWidth)
                            )
                            .padding(.vertical, 5)

                        // Volume area
                        HStack {
                            Text("Volume Level")
                                .padding(.leading, 28)
                            Slider(value: $volumeLevel, in: 0 ... 1, step: 0.1)
                                .padding(.horizontal, 28)
                                .accentColor(Color("Orange"))
                                .onChange(of: volumeLevel) { newValue in
                                    self.volumeLevel = newValue
                                }
                        }.frame(height: 50)
                            .onAppear {
                                self.volumeLevel = Float(alarm.volume) / 100
                                if self.previewState {
                                    MPVolumeView.setVolume(Float(volumeLevel))
                                }
                            }
                            .overlay(
                                overlayRectangleView
                                    .frame(width: overlayRectangleWidth)

                            ).padding(.vertical, 5)

                        // Navigation Tasks
                        Button {
                            isShowingTasks.toggle()
                        } label: {
                            HStack {
                                Text("Tasks")
                                    .padding(.leading, 28)
                                Spacer()
                                Image(systemName: isShowingTasks ? "chevron.down" : "chevron.right")
                                    .padding(.trailing, 28)
                            }.frame(height: 50)
                                .foregroundColor(.white) // temp
                                .overlay(
                                    overlayRectangleView
                                        .frame(width: overlayRectangleWidth)
                                )
                                .padding(.vertical, 5)
                        }
                        
                        // Tasks area
                        if isShowingTasks {
                            withAnimation {
                                VStack {
                                    HStack {
                                        Text("Mathamatics")
                                            .padding(.leading, 28)
                                        Spacer()
                                        Toggle("", isOn: $alarm.tasks[0])
                                            .toggleStyle(SwitchToggleStyle(tint: Color("Orange")))
                                            .onChange(of: vibrateState) { newValue in
                                                self.vibrateState = newValue
                                            }
                                            .padding(.horizontal, 28)
                                    }.frame(height: 50)
                                        .overlay(
                                            overlayRectangleView
                                                .frame(width: overlayRectangleWidth)
                                        )
                                        .padding(.vertical, 5)
                                    HStack {
                                        Text("Simon Says")
                                            .padding(.leading, 28)
                                        Spacer()
                                        Toggle("", isOn: $alarm.tasks[1])
                                            .toggleStyle(SwitchToggleStyle(tint: Color("Orange")))
                                            .onChange(of: vibrateState) { newValue in
                                                self.vibrateState = newValue
                                            }
                                            .padding(.horizontal, 28)
                                    }.frame(height: 50)
                                        .overlay(
                                            overlayRectangleView
                                                .frame(width: overlayRectangleWidth)
                                        )
                                        .padding(.vertical, 5)
                                    HStack {
                                        Text("FaceID")
                                            .padding(.leading, 28)
                                        Spacer()
                                        Toggle("", isOn: $alarm.tasks[2])
                                            .toggleStyle(SwitchToggleStyle(tint: Color("Orange")))
                                            .onChange(of: vibrateState) { newValue in
                                                self.vibrateState = newValue
                                            }
                                            .padding(.horizontal, 28)
                                    }.frame(height: 50)
                                        .overlay(
                                            overlayRectangleView
                                                .frame(width: overlayRectangleWidth)
                                        )
                                        .padding(.vertical, 5)
                                }
                            }
                        }
                        
                        // Navigation Tasks
                        Button {
                            isShowingSensors.toggle()
                        } label: {
                            HStack {
                                Text("Sensors")
                                    .padding(.leading, 28)
                                Spacer()
                                Image(systemName: isShowingTasks ? "chevron.down" : "chevron.right")
                                    .padding(.trailing, 28)
                            }.frame(height: 50)
                                .foregroundColor(.white) // temp
                                .overlay(
                                    overlayRectangleView
                                        .frame(width: overlayRectangleWidth)
                                )
                                .padding(.vertical, 5)
                        }

                        // Sensors area
                        if isShowingSensors {
                            withAnimation {
                                VStack {
                                    HStack {
                                        Text("Gyroscope")
                                            .padding(.leading, 28)
                                        Spacer()
                                        Toggle("", isOn: $alarm.sensors[0])
                                            .toggleStyle(SwitchToggleStyle(tint: Color("Orange")))
                                            .onChange(of: vibrateState) { newValue in
                                                self.vibrateState = newValue
                                            }
                                            .padding(.horizontal, 28)
                                    }.frame(height: 50)
                                        .overlay(
                                            overlayRectangleView
                                                .frame(width: overlayRectangleWidth)
                                        )
                                        .padding(.vertical, 5)
                                    HStack {
                                        Text("Accelerometer")
                                            .padding(.leading, 28)
                                        Spacer()
                                        Toggle("", isOn: $alarm.sensors[1])
                                            .toggleStyle(SwitchToggleStyle(tint: Color("Orange")))
                                            .onChange(of: vibrateState) { newValue in
                                                self.vibrateState = newValue
                                            }
                                            .padding(.horizontal, 28)
                                    }.frame(height: 50)
                                        .overlay(
                                            overlayRectangleView
                                                .frame(width: overlayRectangleWidth)
                                        )
                                        .padding(.vertical, 5)
                                    
                                }
                            }
                        }

                        // Navigation Sensors
                        NavigationLink(destination: AlarmTaskView()) {
                            HStack {
                                Text("Alarm Music")
                                    .padding(.leading, 28)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .padding(.trailing, 28)
                            }
                        }.frame(height: 50)
                            .foregroundColor(.white)
                            .foregroundColor(.blue) // temp
                            .overlay(
                                overlayRectangleView
                                    .frame(width: overlayRectangleWidth)
                            ).padding(.vertical, 5)

                        // Repeat On
                        VStack {
                            HStack {
                                Text("Repeat on:")
                                    .padding(.leading, 12)
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
                                            .bold(alarm.recurringDays.contains(Constants.daysOfWeek[index]) ? true : false)
                                            .foregroundColor(alarm.recurringDays.contains(Constants.daysOfWeek[index]) ? .white : .black)
                                            .padding(.horizontal, 3)
                                            .padding(.vertical, 10)
                                            .background(alarm.recurringDays.contains(Constants.daysOfWeek[index]) ? Color("Orange") : Color.gray)
                                            .cornerRadius(7)
                                    }
                                }
                            }
                        }.padding(.horizontal)
                            .padding(.vertical, 10)
                            .overlay(
                                overlayRectangleView
                                    .frame(width: overlayRectangleWidth)
                            )
                            .padding(.vertical, 5)
                    }
                }

                VStack {
                    // Buttons
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
