//
//  NotificationView.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu on 9.06.2023.
//

import SwiftUI
import SwipeActions

struct NotificationView: View {
    @StateObject var alertService = AlertService.shared
    @ObservedObject var viewModel = NotificationViewModel.shared
    @State private var wrappedVal = 0
    
    init(){
        viewModel.fetchAlarms()
    }

    var body: some View {
        VStack {
            if viewModel.alarms.isEmpty {
                Text("No Alarms")
            } else {
                ScrollView {
                    ForEach(viewModel.alarms, id: \.id) { alarm in
                        SwipeView {
                            AlarmCellView(alarm: alarm, mod: AlarmCellViewMode.notification)
                        } trailingActions: { context in
                            SwipeAction(systemImage: "trash",
                                        backgroundColor: .red) {
                                FireBaseService.shared.declineSharedAlarm(alarm.id.uuidString) { result in
                                    switch result {
                                    case .success:
                                        print("success")
                                        AlertService.shared.showString(title: "Success", message: "Alarm declined successfully")
                                        viewModel.fetchAlarms()
                                    case let .failure(error):
                                        print("error \(error)")
                                        AlertService.shared.show(error: error)
                                    }
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    context.state.wrappedValue = .closed
                                }
                            }.background(Color(red: 1, green: 0, blue: 0))
                                .onChange(of: wrappedVal) { _ in
                                    context.state.wrappedValue = .closed
                                }
                        }
                        .swipeActionsStyle(.cascade)
                        .padding(.horizontal)
                    }
                }
            }
        }.alert(isPresented: $alertService.isPresenting) {
            alertService.alert
        }
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
