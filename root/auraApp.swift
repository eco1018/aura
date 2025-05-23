//
//
//  auraApp.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/27/25.
//

import SwiftUI
import FirebaseCore
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        // Set up notification handling
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
}

// MARK: - Simple Notification Handling
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // Show notifications even when app is open
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    // Handle notification taps
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        
        // Check if it's a diary notification
        if userInfo["openDiary"] as? Bool == true {
            let session = userInfo["session"] as? String ?? "manual"
            
            // Post notification to open diary
            NotificationCenter.default.post(
                name: NSNotification.Name("OpenDiaryCard"),
                object: nil,
                userInfo: ["session": session]
            )
        }
        
        completionHandler()
    }
}

@main
struct AuraApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @StateObject private var authVM = AuthViewModel.shared
    @StateObject private var authSettings = AuthSettings()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authVM)
                .environmentObject(authSettings)
        }
    }
}
