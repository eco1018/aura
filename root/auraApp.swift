
//
// Enhanced auraApp.swift - FIXED Deep Link Notification Handling
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
        print("📔 Processing diary notification for session: \(session)")
        
        // Post notification to trigger diary card opening
        NotificationCenter.default.post(
            name: .openDiaryCard,
            object: nil,
            userInfo: ["session": session, "source": "notification"]
        )
    }
    
    private func handleMedicationNotificationAction(userInfo: [String: Any]) {
        let medicationId = userInfo["medicationId"] as? String ?? ""
        print("💊 Processing medication notification for: \(medicationId)")
        
        // Post notification to trigger medication tracking
        NotificationCenter.default.post(
            name: .openMedicationTracking,
            object: nil,
            userInfo: ["medicationId": medicationId, "source": "notification"]
        )
    }
}

// MARK: - UNUserNotificationCenterDelegate for reliable processing
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // Handle notifications when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("🔔 Notification received while app is active")
        print("   - Title: \(notification.request.content.title)")
        print("   - Body: \(notification.request.content.body)")
        
        // Show notification even when app is active
        completionHandler([.alert, .sound, .badge])
    }
    
    // Handle notification taps with reliable processing
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
    // @StateObject private var authSettings = AuthSettings()
    @StateObject private var appCoordinator = AppCoordinator()

    var body: some Scene {
        WindowGroup {
            // 🔄 CHANGED: Use wrapper instead of RootView directly
            CoordinatorWrapperView()
                .environmentObject(authVM)
                // .environmentObject(authSettings)
                .environmentObject(appCoordinator)
        }
    }
}

// MARK: - Notification Extensions
extension Notification.Name {
    static let openDiaryCard = Notification.Name("openDiaryCard")
    static let openMedicationTracking = Notification.Name("openMedicationTracking")
}
