//
//
//
//
// Enhanced auraApp.swift - Fixed Deep Link Notification Handling
//

//
// Enhanced auraApp.swift - FIXED Deep Link Notification Handling
//

import SwiftUI
import FirebaseCore
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {
    // CRITICAL: Store pending notifications for when app is ready
    private var pendingNotificationAction: [String: Any]?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        // Set up notification handling
        UNUserNotificationCenter.current().delegate = self
        
        // FIXED: Check for LOCAL notification launch (not just remote)
        if let localNotification = launchOptions?[.localNotification] as? UILocalNotification {
            print("🚀 App launched from LOCAL notification")
            // Handle legacy local notification if needed
        }
        
        return true
    }
    
    // MARK: - App Lifecycle for Notifications
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Clear badge when app becomes active
        application.applicationIconBadgeNumber = 0
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        
        // CRITICAL: Process any pending notification actions now that app is active
        if let pendingAction = pendingNotificationAction {
            print("📱 App became active - processing pending notification action")
            processPendingNotificationAction(pendingAction)
            pendingNotificationAction = nil
        }
        
        print("📱 App became active - cleared notifications")
    }
    
    // MARK: - FIXED: Reliable notification action processing
    private func processPendingNotificationAction(_ userInfo: [String: Any]) {
        // Give the app a moment to fully initialize
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.processNotificationAction(userInfo: userInfo)
        }
    }
    
    private func processNotificationAction(userInfo: [String: Any]) {
        print("🔔 === PROCESSING NOTIFICATION ACTION ===")
        print("   - UserInfo: \(userInfo)")
        
        guard let notificationType = userInfo["type"] as? String else {
            print("❌ No notification type found")
            return
        }
        
        switch notificationType {
        case "diary":
            handleDiaryNotificationAction(userInfo: userInfo)
        case "medication":
            handleMedicationNotificationAction(userInfo: userInfo)
        default:
            print("⚠️ Unknown notification type: \(notificationType)")
        }
    }
    
    private func handleDiaryNotificationAction(userInfo: [String: Any]) {
        let session = userInfo["session"] as? String ?? "manual"
        
        print("📔 Processing diary notification:")
        print("   - Session: \(session)")
        
        // Post notification for MainView to pick up
        NotificationCenter.default.post(
            name: NSNotification.Name("OpenDiaryCard"),
            object: nil,
            userInfo: ["session": session]
        )
        
        print("✅ Posted OpenDiaryCard notification")
    }
    
    private func handleMedicationNotificationAction(userInfo: [String: Any]) {
        let medicationName = userInfo["medicationName"] as? String ?? "your medication"
        
        print("💊 Processing medication notification:")
        print("   - Medication: \(medicationName)")
        
        // TODO: Open medication tracking view or show reminder
        // For now, just clear badge
        NotificationHelper.clearBadge()
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
        print("   - UserInfo: \(userInfo)")
        
        // Show notifications even when app is in foreground
        completionHandler([.alert, .sound, .badge])
    }
    
    // ENHANCED: Handle notification taps with reliable processing
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        let notificationId = response.notification.request.identifier
        
        print("🔔 === NOTIFICATION TAP RECEIVED ===")
        print("   - ID: \(notificationId)")
        print("   - Title: \(response.notification.request.content.title)")
        print("   - UserInfo: \(userInfo)")
        
        // Convert userInfo to String dictionary for easier handling
        var stringUserInfo: [String: Any] = [:]
        for (key, value) in userInfo {
            stringUserInfo[String(describing: key)] = value
        }
        
        // Check if app is in background/inactive - if so, store for later processing
        let appState = UIApplication.shared.applicationState
        print("   - App State: \(appState.rawValue)")
        
        if appState != .active {
            print("📦 App not active - storing notification for later processing")
            pendingNotificationAction = stringUserInfo
        } else {
            print("🚀 App is active - processing notification immediately")
            processNotificationAction(userInfo: stringUserInfo)
        }
        
        // Clear the notification badge
        DispatchQueue.main.async {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        
        print("=== END NOTIFICATION TAP ===")
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
