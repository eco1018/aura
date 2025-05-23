//
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
    
    // MARK: - App Lifecycle for Notifications
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Clear badge when app becomes active
        application.applicationIconBadgeNumber = 0
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // You can add any cleanup here if needed
    }
    
    // MARK: - Background Notification Handling
    func application(_ application: UIApplication,
                    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // If you ever want to add push notifications later
        print("📱 Registered for remote notifications")
    }
    
    func application(_ application: UIApplication,
                    didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("❌ Failed to register for remote notifications: \(error)")
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
        
        // Check if it's a medication notification
        if userInfo["type"] as? String == "medication" {
            let medicationName = userInfo["medicationName"] as? String ?? "your medication"
            print("💊 User tapped medication reminder for: \(medicationName)")
            
            // You can add specific medication reminder handling here later
            // For now, just clear the badge
            NotificationHelper.clearBadge()
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
