//
//
//
//  auraApp.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/27/25.
//

//
// Updated auraApp.swift - Fixed AppDelegate Notification Handling
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

// MARK: - Enhanced Notification Handling
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // Show notifications even when app is open
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Show notifications even when app is in foreground
        completionHandler([.alert, .sound, .badge])
    }
    
    // FIXED: Handle notification taps with better debugging
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        let notificationId = response.notification.request.identifier
        
        print("🔔 Notification tapped:")
        print("   - ID: \(notificationId)")
        print("   - UserInfo: \(userInfo)")
        
        // FIXED: Better diary notification handling
        if let notificationType = userInfo["type"] as? String {
            switch notificationType {
            case "diary":
                handleDiaryNotification(userInfo: userInfo)
            case "medication":
                handleMedicationNotification(userInfo: userInfo)
            default:
                print("⚠️ Unknown notification type: \(notificationType)")
            }
        } else {
            print("⚠️ No notification type found in userInfo")
        }
        
        // Clear the notification badge
        DispatchQueue.main.async {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        
        completionHandler()
    }
    
    // MARK: - Specific Notification Handlers
    
    private func handleDiaryNotification(userInfo: [AnyHashable: Any]) {
        guard let openDiary = userInfo["openDiary"] as? Bool, openDiary == true else {
            print("⚠️ Diary notification doesn't have openDiary flag")
            return
        }
        
        let session = userInfo["session"] as? String ?? "manual"
        
        print("📔 Handling diary notification:")
        print("   - Session: \(session)")
        print("   - Posting NotificationCenter event...")
        
        // Post to NotificationCenter with delay to ensure app is ready
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            NotificationCenter.default.post(
                name: NSNotification.Name("OpenDiaryCard"),
                object: nil,
                userInfo: ["session": session]
            )
            print("✅ Posted OpenDiaryCard notification to NotificationCenter")
        }
    }
    
    private func handleMedicationNotification(userInfo: [AnyHashable: Any]) {
        let medicationName = userInfo["medicationName"] as? String ?? "your medication"
        let medicationId = userInfo["medicationId"] as? String ?? "unknown"
        
        print("💊 Handling medication notification:")
        print("   - Medication: \(medicationName)")
        print("   - ID: \(medicationId)")
        
        // You can add specific medication reminder handling here later
        // For now, just clear the badge
        NotificationHelper.clearBadge()
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
