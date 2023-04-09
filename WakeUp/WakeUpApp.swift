//
//  WakeUpApp.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu on 10.04.2023.
//

import SwiftUI

@main
struct WakeUpApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
