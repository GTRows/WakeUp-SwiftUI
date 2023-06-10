//
//  AlarmListViewModel.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu on 16.05.2023.
//

import Foundation
import SwiftUI
import CoreData

class AlarmListViewModel: ObservableObject {
    @Published var alarms: [Alarm] = []
    @Published var selectedAlarm: Alarm?
    
    func fetchAlarms() {
        let request: NSFetchRequest<Alarm> = Alarm.fetchRequest()
        
        do {
            self.alarms = try PersistenceController.shared.container.viewContext.fetch(request)
        } catch {
            print("Error fetching alarms: \(error)")
        }
    }
    
    func deleteAlarm(alarm: Alarm) {
        DatabaseService.shared.deleteAlarm(alarm: alarm)
        fetchAlarms()
    }
}
