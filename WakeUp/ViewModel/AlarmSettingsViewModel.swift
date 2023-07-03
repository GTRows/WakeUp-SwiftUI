import CoreData
import Foundation
import SwiftUI

enum AlarmAction {
    case add, edit
}

class AlarmSettingsViewModel: ObservableObject {
    let context: NSManagedObjectContext
    @Published var alarm: AlarmModel
    var recurringDays: Binding<[String]> { Binding(get: { self.alarm.recurringDays }, set: { self.alarm.recurringDays = $0 }) }


    init(alarm: AlarmModel, context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.alarm = alarm
        self.context = context
    }

    func previewAlarm() {
        // Show an alert view to simulate the alarm ring
        let alert = UIAlertController(title: "Wake up!", message: "It's time to wake up.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootViewController = window.rootViewController {
            rootViewController.present(alert, animated: true)
        }
    }

    func setAlarm(volumeLevel: Float, action: AlarmAction, tone: String, wakeUpTime: Date) {
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUpTime)
        alarm.tone = tone // select area not created
        alarm.hour = components.hour ?? 0
        alarm.minute = components.minute ?? 0
        alarm.volume = Int(volumeLevel * 100)

        switch action {
        case .add:
            addAlarm()
        case .edit:
            editAlarm()
        }
    }

    func addAlarm() {
        DatabaseService.shared.addAlarm(alarm: alarm)
    }

    public func editAlarm() {
        DatabaseService.shared.editAlarm(alarm: alarm)
    }
}
