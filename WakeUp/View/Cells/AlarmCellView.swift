//
//  AlarmCellView.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu on 11.04.2023.
//

import SwiftUI

enum AlarmCellViewMode {
    case edit
    case notification
    case addPackage
}

struct AlarmCellView: View {
    @StateObject var alertService = AlertService.shared
    @State var alarm: AlarmModel
    @State private var alarmHour = 0
    @State private var alarmTime = ""
    @State private var isOn = true

    let cellWidth: CGFloat = UIScreen.main.bounds.width - 40
    let cellHeight: CGFloat = 135
    let cellCornerRadius: CGFloat = 16

    @State var mod: AlarmCellViewMode
    var isActiveToggle: Bool?

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cellCornerRadius)
                .fill(Color(#colorLiteral(red: 0.2083333283662796, green: 0.2083333283662796, blue: 0.2083333283662796, alpha: 1)))
                .frame(width: cellWidth, height: cellHeight)
            VStack {
                HStack {
                    Text(alarm.name)
                        .font(.system(size: 16))
                        .bold()
                        .padding(.leading, 35)
                        .frame(alignment: .leading)
                        .foregroundColor(Color(.white))
                    Spacer()
                }
                HStack {
                    Text("")
                        .padding(.horizontal)
                    Text(alarmTime)
                        .font(.custom("Oxygen Bold", size: 32))
                        .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))) + Text(" ")
                        .font(.custom("Oxygen Regular", size: 18)).foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                    Spacer()
                    if mod == .edit {
                        Toggle("", isOn: $isOn)
                            .toggleStyle(SwitchToggleStyle(tint: Color("Orange")))
                            .padding(.trailing, 50)
                            .onChange(of: isOn) { newValue in
                                alarm.active = newValue ? .active : .inactive
                                let viewModel = AlarmSettingsViewModel(alarm: alarm)
                                viewModel.editAlarm()
                            }
                    } else if mod == .notification {
                        Button {
                            isOn = true
                            FireBaseService.shared.acceptSharedAlarm(alarm.id.uuidString) { result in
                                switch result {
                                case .success():
                                    AlertService.shared.showString(title: "Success", message: "Alarm accepted")
                                case let .failure(error):
                                    AlertService.shared.show(error: error)
                                }
                            }
                            NotificationViewModel.shared.removeAlarm(from: alarm)
                        } label: {
                            Text("Add Alarm")
                                .font(.custom("Oxygen Regular", size: 16))
                                .foregroundColor(.black)
                                .padding(10)
                                .background(Color("Orange"))
                                .cornerRadius(20)
                                .padding(.trailing, 50)
                        }
                    } else if mod == .addPackage {
                        Toggle(isOn: $isOn) {
                                }
                                .toggleStyle(CheckboxToggleStyle())
                                .padding(.trailing, 50)
                                
                    } else {
                        Text("Unknown")
                            .task {
                                AlertService.shared.showString(title: "Unknown Error", message: "AlarmCellView mod undefined")
                            }
                    }
                }

                ZStack {
                    Rectangle()
                        .fill(Color(#colorLiteral(red: 0.27916666865348816, green: 0.27916666865348816, blue: 0.27916666865348816, alpha: 0.7200000286102295)))
                        .clipShape(RoundedRectangle(cornerRadius: cellCornerRadius)
                            .path(in: CGRect(x: 0, y: 0, width: cellWidth, height: 40)))
                        .frame(width: cellWidth, height: 40)
                    HStack {
                        Text("Repeat")
                            .font(.custom("Oxygen Regular", size: 16))
                            .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                            .padding(.leading, 40)
                        Spacer()
                        if alarm.recurringDays.isEmpty {
                            Text("Never")
                                .font(.custom("Oxygen Regular", size: 16))
                                .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                                .padding(.trailing, 30)
                        } else {
                            Text(alarm.recurringDays.joined(separator: ", "))
                                .font(.custom("Oxygen Regular", size: 16))
                                .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                                .padding(.trailing, 30)
                        }
                    }
                }
            }
        }
        .onChange(of: isOn) { newValue in
            if newValue {
                AlarmService.shared.addPackageAlarms(alarm: alarm)
            } else{
                AlarmService.shared.removePackageAlarms(alarm: alarm)
            
            }
        }
        .onAppear {
            alarmTime = "\(alarm.hour):\(alarm.minute)"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            if let date = dateFormatter.date(from: "\(alarm.hour):\(alarm.minute)") {
                dateFormatter.dateFormat = "hh:mm a"
                let dateString = dateFormatter.string(from: date)
                self.alarmTime = dateString
            }

            // active
            if mod == .edit {
                if alarm.active == .active {
                    isOn = true
                } else if alarm.active == .inactive {
                    isOn = false
                } else {
                    isOn = true
                }
            } else if mod == .notification {
                isOn = false
            } else if mod == .addPackage {
                if isActiveToggle == true {
                    isOn = true
                } else {
                    isOn = false
                }
            }
        }
        .alert(isPresented: $alertService.isPresenting) {
            alertService.alert
        }
    }
}

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(configuration.isOn ? .blue : .gray)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
    }
}

struct AlarmCellView_Previews: PreviewProvider {
    @State var addAlarmButton: Bool = false

    static var previews: some View {
//        AlarmCellView(alarm: AlarmModel(), mod: AlarmCellViewMode.notification) // notification
//        AlarmCellView(alarm: AlarmModel(), mod: AlarmCellViewMode.edit) // notification
        AlarmCellView(alarm: AlarmModel(), mod: AlarmCellViewMode.addPackage, isActiveToggle: true) // notification
    }
}
