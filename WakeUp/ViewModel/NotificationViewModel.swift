//
//  NotificationView.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu on 9.06.2023.
//

import Foundation

class NotificationViewModel: ObservableObject {
    @Published var alarms: [AlarmModel] = []
    public static let shared = NotificationViewModel()

    private init() {
        fetchAlarms()
    }

    func fetchAlarms() {
        var user = FireBaseService.shared.getUser()
        
        FireBaseService.shared.fetchSharedAlarms(forEmail: user.email) { alarms, error in
            if let error = error {
                print("error \(error)")
            } else if let alarms = alarms {
                DispatchQueue.main.async {
                    self.alarms = alarms
                }
            } else {
                print("Unknown error")
            }
        }
    }

    func removeAlarm(from: AlarmModel) {
        if let index = alarms.firstIndex(where: { $0.id == from.id }) {
            alarms.remove(at: index)
        }
    }
}
