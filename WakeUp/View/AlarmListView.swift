//
//  AlarmListView.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu
//

import SwiftUI
import SwipeActions

struct AlarmListView: View {
    @StateObject private var viewModel = AlarmListViewModel()
    @State private var shouldPopToRootView = false
    @State private var isShowingPopover = false
    @State private var selectedAlarm: Alarm? = nil
    @State private var wrappedVal = 0
    @State private var isSharingAlarm = false
    @State private var emailToShare: String = ""
    @State private var isAddPackage: Bool = false
    @State private var buttonText: String = "Add Alarm"
    @State private var isCreatingPackage: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Alarms")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.leading, 16)
                    Spacer()
                    if isAddPackage {
                        Button {
                            isAddPackage = false
                            selectedAlarm = nil
                        } label: {
                            Text("Cancel")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(
                                    Color(.red)
                                )
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color(.red), lineWidth: 1)
                                )
                                .padding(.trailing, 16)
                        }
                    }

                    Button {
                        if isAddPackage {
                            isCreatingPackage = true
                        } else {
                            self.isShowingPopover = true
                            wrappedVal += 1
                        }
                    } label: {
                        Text(buttonText)
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(
                                Color("Orange")
                            )
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color("Orange"), lineWidth: 1)
                            )
                            .padding(.trailing, 16)
                    }
                    .sheet(isPresented: $isShowingPopover, onDismiss: {
                        viewModel.fetchAlarms()
                    }) {
                        AlarmSettingsView(alarm: AlarmModel(), action: AlarmAction.add)
                    }
                }
                .padding(.top, 16)
                ScrollView(.vertical, showsIndicators: false) {
                    if !isAddPackage {
                        ForEach(viewModel.alarms, id: \.id) { alarm in
                            SwipeView {
                                AlarmCellView(alarm: AlarmModel(from: alarm), mod: AlarmCellViewMode.edit)
                            } leadingActions: { context in
                                SwipeAction("Create Package") {
                                    AlarmService.shared.clearPackageAlarms()
                                    self.selectedAlarm = alarm
                                    AlarmService.shared.addPackageAlarms(alarm: AlarmModel(from: alarm))
                                    isAddPackage = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        context.state.wrappedValue = .closed
                                    }
                                }.background(.blue)
                                SwipeAction(systemImage: "square.and.arrow.up",
                                            backgroundColor: .purple) {
                                    // Share Alarm
                                    selectedAlarm = alarm
                                    isSharingAlarm = true
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        context.state.wrappedValue = .closed
                                    }
                                }.onChange(of: wrappedVal) { _ in
                                    context.state.wrappedValue = .closed
                                }
                            } trailingActions: { context in
                                SwipeAction("Edit") {
                                    viewModel.selectedAlarm = alarm
                                    self.selectedAlarm = alarm
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        context.state.wrappedValue = .closed
                                    }
                                }.background(Color("DarkGray"))
                                SwipeAction("Delete") {
                                    viewModel.deleteAlarm(alarm: alarm)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        context.state.wrappedValue = .closed
                                    }
                                }.background(Color(red: 1, green: 0, blue: 0))
                                    .onChange(of: wrappedVal) { _ in
                                        context.state.wrappedValue = .closed
                                    }
                            }.swipeActionsStyle(.cascade)
                                .padding(.horizontal)
                        }
                    } else {
                        ForEach(viewModel.alarms, id: \.id) { alarm in
                            if selectedAlarm == alarm {
                                AlarmCellView(alarm: AlarmModel(from: alarm), mod: AlarmCellViewMode.addPackage, isActiveToggle: true)
                                    .padding(.horizontal)
                            } else {
                                AlarmCellView(alarm: AlarmModel(from: alarm), mod: AlarmCellViewMode.addPackage, isActiveToggle: false)
                                    .padding(.horizontal)
                            }
                        }
                    }
                }
            }
            .navigationTitle("")
            .onChange(of: isAddPackage, perform: { _ in
                if isAddPackage {
                    buttonText = "Create Package"
                } else {
                    buttonText = "Add Alarm"
                }
            })
            .sheet(isPresented: $isCreatingPackage) {
                CreatePackageView()
            }
            .sheet(isPresented: $isSharingAlarm) {
                VStack {
                    Text("Share Alarm")
                        .font(.title)
                    TextField("Enter email", text: $emailToShare)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    Button("Share") {
                        FireBaseService.shared.shareAlarm(AlarmModel(from: selectedAlarm!), withEmail: emailToShare) { error in
                            if let error = error {
                                // error handling
                                print(error.localizedDescription)
                            } else {
                                // success handling
                                print("Alarm successfully shared!")
                                isSharingAlarm = false
                            }
                        }
                    }
                    .padding()
                    Button("Cancel") {
                        isSharingAlarm = false
                    }
                    .padding()
                }
            }
            .sheet(item: $viewModel.selectedAlarm, onDismiss: {
                viewModel.fetchAlarms()
                shouldPopToRootView = false
            }) { alarm in
                AlarmSettingsView(alarm: AlarmModel(from: alarm), action: AlarmAction.edit)
            }
        }
        .onAppear {
            viewModel.fetchAlarms()
        }
        .onChange(of: shouldPopToRootView) { value in
            if value {
                viewModel.fetchAlarms()
                shouldPopToRootView = false
            }
        }
    }
}

struct AlarmListView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmListView()
    }
}
