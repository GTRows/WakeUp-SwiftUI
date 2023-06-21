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

class CombinedAppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // NotificationDelegate'den gelen kod
        FirebaseApp.configure() // Firebase'i yapılandır
        UNUserNotificationCenter.current().delegate = self

        // AppDelegate'den gelen kod
        // ... buraya ilgili kodları ekleyin

        return true
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }

    // Diğer AppDelegate metodları
    // ... buraya ilgili kodları ekleyin
}

@main
struct WakeUpApp: App {
    @UIApplicationDelegateAdaptor(CombinedAppDelegate.self) var delegate
    @StateObject private var authViewModel = AuthViewModel()
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            InitialView()
        }
    }
}
