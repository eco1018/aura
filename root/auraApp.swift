//
//
//
//
// Enhanced auraApp.swift - Fixed Deep Link Notification Handling
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
        
        // Check if app was launched from notification
        if let notificationResponse = launchOptions?[.remoteNotification] as? [AnyHashable: Any] {
            print("🚀 App launched from notification: \(notificationResponse)")
            handleLaunchFromNotification(userInfo: notificationResponse)
        }
        
        return true
    }
    
    // MARK: - App Lifecycle for Notifications
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Clear badge when app becomes active
        application.applicationIconBadgeNumber = 0
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        print("📱 App became active - cleared notifications")
    }
    
    // MARK: - Launch from Notification Handler
    private func handleLaunchFromNotification(userInfo: [AnyHashable: Any]) {
        // Handle when app is launched from notification (cold start)
        if let type = userInfo["type"] as? String, type == "diary" {
            let session = userInfo["session"] as? String ?? "manual"
            print("🚀 App launched from diary notification - session: \(session)")
            
            // Delay to ensure app is fully loaded
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                NotificationCenter.default.post(
                    name: NSNotification.Name("OpenDiaryCard"),
                    object: nil,
                    userInfo: ["session": session]
                )
                print("✅ Posted delayed OpenDiaryCard notification")
            }
        }
    }
}

// MARK: - Enhanced Notification Handling
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // Show notifications even when app is open
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        print("🔔 Will present notification while app is open:")
        print("   - Title: \(notification.request.content.title)")
        print("   - Body: \(notification.request.content.body)")
        print("   - UserInfo: \(userInfo)")
        
        // Show notifications even when app is in foreground
        completionHandler([.alert, .sound, .badge])
    }
    
    // ENHANCED: Handle notification taps with comprehensive debugging
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        let notificationId = response.notification.request.identifier
        let actionId = response.actionIdentifier
        
        print("🔔 === NOTIFICATION TAP DEBUG ===")
        print("   - Notification ID: \(notificationId)")
        print("   - Action ID: \(actionId)")
        print("   - Title: \(response.notification.request.content.title)")
        print("   - Body: \(response.notification.request.content.body)")
        print("   - UserInfo: \(userInfo)")
        print("   - UserInfo Keys: \(userInfo.keys)")
        
        // Check for diary notification specifically
        if let notificationType = userInfo["type"] as? String {
            print("   - Notification Type: \(notificationType)")
            
            switch notificationType {
            case "diary":
                handleDiaryNotification(userInfo: userInfo)
            case "medication":
                handleMedicationNotification(userInfo: userInfo)
            default:
                print("⚠️ Unknown notification type: \(notificationType)")
            }
        } else {
            print("❌ CRITICAL: No 'type' key found in userInfo!")
            print("   - Available keys: \(Array(userInfo.keys))")
            
            // Fallback: Check for any diary-related keys
            if userInfo["openDiary"] != nil || userInfo["session"] != nil {
                print("🔄 Fallback: Found diary-related keys, treating as diary notification")
                handleDiaryNotification(userInfo: userInfo)
            }
        }
        
        // Clear the notification badge
        DispatchQueue.main.async {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        
        print("=== END NOTIFICATION DEBUG ===")
        completionHandler()
    }
    
    // MARK: - Specific Notification Handlers
    
    private func handleDiaryNotification(userInfo: [AnyHashable: Any]) {
        print("📔 === DIARY NOTIFICATION HANDLER ===")
        
        // Check multiple possible keys for diary notifications
        let openDiary = userInfo["openDiary"] as? Bool ??
                       (userInfo["action"] as? String == "openDiaryCard") ??
                       (userInfo["type"] as? String == "diary")
        
        guard openDiary else {
            print("❌ Diary notification validation failed:")
            print("   - openDiary: \(userInfo["openDiary"] ?? "nil")")
            print("   - action: \(userInfo["action"] ?? "nil")")
            print("   - type: \(userInfo["type"] ?? "nil")")
            return
        }
        
        let session = userInfo["session"] as? String ?? "manual"
        
        print("✅ Diary notification validated:")
        print("   - Session: \(session)")
        print("   - Posting NotificationCenter event...")
        
        // Multiple attempts with different delays to ensure delivery
        let delays: [Double] = [0.1, 0.5, 1.0]
        
        for (index, delay) in delays.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                NotificationCenter.default.post(
                    name: NSNotification.Name("OpenDiaryCard"),
                    object: nil,
                    userInfo: ["session": session, "attempt": index + 1]
                )
                print("📬 Posted OpenDiaryCard notification (attempt \(index + 1)) with delay \(delay)s")
            }
        }
        
        print("=== END DIARY HANDLER ===")
    }
    
    private func handleMedicationNotification(userInfo: [AnyHashable: Any]) {
        let medicationName = userInfo["medicationName"] as? String ?? "your medication"
        let medicationId = userInfo["medicationId"] as? String ?? "unknown"
        
        print("💊 Handling medication notification:")
        print("   - Medication: \(medicationName)")
        print("   - ID: \(medicationId)")
        
        // Clear the badge for medication notifications
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
