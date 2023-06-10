//
//  WakeUpApp.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu
//

import FirebaseCore
import Swift
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct WakeUpApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authViewModel = AuthViewModel()
    let persistenceController = PersistenceController.shared


    var body: some Scene {
        WindowGroup {
            InitialView()
        }
    }
}
