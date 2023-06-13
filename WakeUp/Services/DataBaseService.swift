//
//  DataBaseService.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu on 4.06.2023.
//

import Foundation
import CoreData


final class DatabaseService {
    static let shared = DatabaseService()
    private let context = PersistenceController.shared.container.viewContext
    
    
    private init() {
    }
    
    // Save changes function
    func saveChanges() {
        do {
            try context.save()
        } catch {
            print("Error saving changes: \(error)")
        }
    }
    
    // MARK: - Alarm CRUD Operations
    
    func fetchAlarms() -> [AlarmModel] {
        var alarms: [AlarmModel] = []
        let fetchRequest: NSFetchRequest<Alarm> = Alarm.fetchRequest()
        do {
            let fetchedAlarms = try context.fetch(fetchRequest)
            for alarm in fetchedAlarms {
                alarms.append(AlarmModel(from: alarm))
            }
        } catch {
            print("Failed to fetch alarms: \(error)")
        }
        return alarms
    }
    
    
    func addAlarm(alarm: AlarmModel) {
        let newAlarm = Alarm(context: context)
        newAlarm.id = alarm.id
        newAlarm.name = alarm.name
        newAlarm.active = alarm.active.rawValue
        newAlarm.vibrate = alarm.vibrate.rawValue
        newAlarm.tone = alarm.tone
        newAlarm.hour = Int16(alarm.hour)
        newAlarm.minute = Int16(alarm.minute)
        newAlarm.volume = Int16(alarm.volume)
        newAlarm.recurringDays = NSArray(array: alarm.recurringDays)
        
        do {
            try context.save()
            print("Saved new alarm: \(alarm.name)")
        } catch {
            print("Failed to save new alarm: \(error)")
        }
    }
    
    func editAlarm(alarm: AlarmModel) {
        let fetchRequest: NSFetchRequest<Alarm> = Alarm.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", alarm.id as CVarArg)
        do {
            let fetchedAlarms = try context.fetch(fetchRequest)
            if let alarmToBeEdited = fetchedAlarms.first {
                // Edit the existing alarm
                alarmToBeEdited.name = alarm.name
                alarmToBeEdited.active = alarm.active.rawValue
                alarmToBeEdited.vibrate = alarm.vibrate.rawValue
                alarmToBeEdited.tone = alarm.tone
                alarmToBeEdited.hour = Int16(alarm.hour)
                alarmToBeEdited.minute = Int16(alarm.minute)
                alarmToBeEdited.volume = Int16(alarm.volume)
                alarmToBeEdited.recurringDays = NSArray(array: alarm.recurringDays)
                
                do {
                    try context.save()
                    print("Edited alarm: \(alarm.name)")
                } catch {
                    print("Failed to edit alarm: \(error)")
                }
            }
        } catch {
            print("Failed to fetch alarm: \(error)")
        }
    }
    
    func deleteAlarm(alarm: Alarm) {
        context.delete(alarm)
        saveChanges()
    }
    
}
