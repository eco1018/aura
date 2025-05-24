//
//
// Enhanced NotificationHelper.swift - Better Deep Link Testing
//

import Foundation
import UserNotifications
import UIKit

struct NotificationHelper {
    
    // MARK: - Badge Management
    static func clearBadge() {
        DispatchQueue.main.async {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    static func setBadge(count: Int) {
        DispatchQueue.main.async {
            UIApplication.shared.applicationIconBadgeNumber = count
        }
    }
    
    // MARK: - Quick Notification Actions
    static func sendImmediateNotification(title: String, body: String, identifier: String = "immediate") {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Failed to send immediate notification: \(error)")
            }
        }
    }
    
    // MARK: - Permission Check
    static func checkPermissionStatus() async -> UNAuthorizationStatus {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        return settings.authorizationStatus
    }
    
    // MARK: - ENHANCED Test Diary Notification
    static func testDiaryNotification(session: String = "evening") {
        print("🧪 === TESTING DIARY NOTIFICATION ===")
        print("   - Session: \(session)")
        print("   - Will fire in 5 seconds...")
        
        Task {
            let hasPermission = await SimpleNotificationService.shared.requestPermission()
            
            if hasPermission {
                let content = UNMutableNotificationContent()
                content.title = "🧪 Test: Diary Reminder"
                content.body = "Tap to test deep link to diary card!"
                content.sound = .default
                content.badge = 1
                
                // CRITICAL: Match exact format used in production notifications
                content.userInfo = [
                    "type": "diary",
                    "openDiary": true,
                    "session": session,
                    "action": "openDiaryCard",
                    "isTest": true  // Add test flag for debugging
                ]
                
                print("   - Content UserInfo: \(content.userInfo)")
                
                let identifier = "test_diary_\(Int(Date().timeIntervalSince1970))"
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("❌ Failed to schedule test diary notification: \(error)")
                    } else {
                        print("✅ Test diary notification scheduled:")
                        print("   - ID: \(identifier)")
                        print("   - Session: \(session)")
                        print("   - Will appear in 5 seconds")
                        print("   - Tap it to test deep link!")
                    }
                }
            } else {
                print("❌ No notification permission - cannot test")
                print("   - Go to Settings → Notifications → Your App to enable")
            }
        }
    }
    
    // MARK: - Test Different Session Types
    static func testMorningDiaryNotification() {
        print("🌅 Testing MORNING diary notification...")
        testDiaryNotification(session: "morning")
    }
    
    static func testEveningDiaryNotification() {
        print("🌙 Testing EVENING diary notification...")
        testDiaryNotification(session: "evening")
    }
    
    static func testManualDiaryNotification() {
        print("⏰ Testing MANUAL diary notification...")
        testDiaryNotification(session: "manual")
    }
    
    // MARK: - Test All Session Types
    static func testAllDiaryNotifications() {
        print("🔥 Testing ALL diary notification types...")
        
        // Schedule them with different delays
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            testMorningDiaryNotification()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
            testEveningDiaryNotification()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
            testManualDiaryNotification()
        }
        
        print("📅 Scheduled 3 test notifications:")
        print("   - Morning: in 6 seconds")
        print("   - Evening: in 13 seconds")
        print("   - Manual: in 20 seconds")
    }
    
    // MARK: - Quick Setup for Testing
    static func setupTestNotifications() {
        Task {
            let hasPermission = await SimpleNotificationService.shared.requestPermission()
            
            if hasPermission {
                // Schedule a test notification in 10 seconds
                let content = UNMutableNotificationContent()
                content.title = "Aura Test"
                content.body = "Notifications are working! 🎉"
                content.sound = .default
                content.userInfo = ["type": "test"]
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
                let request = UNNotificationRequest(identifier: "test_10s", content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("❌ Failed to schedule test notification: \(error)")
                    } else {
                        print("✅ Test notification scheduled for 10 seconds")
                    }
                }
            }
        }
    }
    
    // MARK: - Enhanced Debug Methods
    static func debugNotifications() {
        print("🔍 === NOTIFICATION DEBUG INFO ===")
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            print("📋 Currently scheduled notifications (\(requests.count)):")
            
            if requests.isEmpty {
                print("   ❌ No notifications scheduled!")
                print("   💡 Try running setupTestNotifications() or testDiaryNotification()")
            } else {
                for request in requests {
                    print("   📌 \(request.identifier):")
                    print("      Title: \(request.content.title)")
                    print("      Body: \(request.content.body)")
                    print("      UserInfo: \(request.content.userInfo)")
                    
                    if let trigger = request.trigger as? UNCalendarNotificationTrigger {
                        let components = trigger.dateComponents
                        let timeStr = "\(components.hour ?? 0):\(String(format: "%02d", components.minute ?? 0))"
                        print("      Time: \(timeStr) (repeats: \(trigger.repeats))")
                    } else if let trigger = request.trigger as? UNTimeIntervalNotificationTrigger {
                        let timeLeft = trigger.timeInterval
                        print("      Fires in: \(timeLeft)s (repeats: \(trigger.repeats))")
                    }
                    print("      ---")
                }
            }
        }
        
        // Also check notification settings
        Task {
            let settings = await UNUserNotificationCenter.current().notificationSettings()
            print("⚙️ Notification settings:")
            print("   Authorization: \(settings.authorizationStatus.rawValue) (\(authStatusString(settings.authorizationStatus)))")
            print("   Alert: \(settings.alertSetting.rawValue) (\(settingString(settings.alertSetting)))")
            print("   Badge: \(settings.badgeSetting.rawValue) (\(settingString(settings.badgeSetting)))")
            print("   Sound: \(settings.soundSetting.rawValue) (\(settingString(settings.soundSetting)))")
            print("=== END DEBUG INFO ===")
        }
    }
    
    // MARK: - Helper Methods for Debug Output
    private static func authStatusString(_ status: UNAuthorizationStatus) -> String {
        switch status {
        case .notDetermined: return "Not Determined"
        case .denied: return "DENIED"
        case .authorized: return "AUTHORIZED"
        case .provisional: return "Provisional"
        case .ephemeral: return "Ephemeral"
        @unknown default: return "Unknown"
        }
    }
    
    private static func settingString(_ setting: UNNotificationSetting) -> String {
        switch setting {
        case .notSupported: return "Not Supported"
        case .disabled: return "DISABLED"
        case .enabled: return "ENABLED"
        @unknown default: return "Unknown"
        }
    }
    
    // MARK: - Comprehensive Test Suite
    static func runComprehensiveTest() {
        print("🚀 === COMPREHENSIVE NOTIFICATION TEST ===")
        
        Task {
            // 1. Check permissions
            let status = await checkPermissionStatus()
            print("1️⃣ Permission Status: \(authStatusString(status))")
            
            if status != .authorized {
                print("   ❌ Notifications not authorized - requesting permission...")
                let granted = await SimpleNotificationService.shared.requestPermission()
                print("   \(granted ? "✅" : "❌") Permission \(granted ? "granted" : "denied")")
                
                if !granted {
                    print("   ⚠️ Cannot continue test without notification permission")
                    return
                }
            }
            
            // 2. Clear existing notifications
            print("2️⃣ Clearing existing notifications...")
            SimpleNotificationService.shared.clearAll()
            
            // 3. Test immediate notification
            print("3️⃣ Testing immediate notification...")
            sendImmediateNotification(
                title: "Test: Immediate",
                body: "This should appear right away",
                identifier: "test_immediate"
            )
            
            // 4. Test diary notification with delay
            print("4️⃣ Testing diary notification (5s delay)...")
            testDiaryNotification(session: "evening")
            
            // 5. Debug current state
            print("5️⃣ Current notification state:")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                debugNotifications()
            }
            
            print("✅ Comprehensive test initiated - watch for notifications!")
        }
    }
}
