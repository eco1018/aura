//
//  NotificationHelper.swift
//  aura
//
//
// NotificationHelper.swift - Enhanced with debugging
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
    
    // MARK: - Test Diary Notification (NEW)
    static func testDiaryNotification(session: String = "evening") {
        Task {
            let hasPermission = await SimpleNotificationService.shared.requestPermission()
            
            if hasPermission {
                let content = UNMutableNotificationContent()
                content.title = "Test Diary Reminder"
                content.body = "Testing diary card deep link - tap to open!"
                content.sound = .default
                content.badge = 1
                
                // Match the exact format used in production
                content.userInfo = [
                    "type": "diary",
                    "openDiary": true,
                    "session": session,
                    "action": "openDiaryCard"
                ]
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                let request = UNNotificationRequest(identifier: "test_diary_\(Date().timeIntervalSince1970)", content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("❌ Failed to schedule test diary notification: \(error)")
                    } else {
                        print("✅ Test diary notification scheduled for 5 seconds - session: \(session)")
                    }
                }
            } else {
                print("❌ No notification permission for test")
            }
        }
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
    
    // MARK: - Debug Current Notifications
    static func debugNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            print("🔍 DEBUG: Currently scheduled notifications (\(requests.count)):")
            for request in requests {
                print("   📋 ID: \(request.identifier)")
                print("      Title: \(request.content.title)")
                print("      UserInfo: \(request.content.userInfo)")
                if let trigger = request.trigger as? UNCalendarNotificationTrigger {
                    let components = trigger.dateComponents
                    print("      Time: \(components.hour ?? 0):\(String(format: "%02d", components.minute ?? 0))")
                } else if let trigger = request.trigger as? UNTimeIntervalNotificationTrigger {
                    print("      Interval: \(trigger.timeInterval)s")
                }
                print("      ---")
            }
        }
        
        // Also check notification settings
        Task {
            let settings = await UNUserNotificationCenter.current().notificationSettings()
            print("🔍 DEBUG: Notification settings:")
            print("   Authorization: \(settings.authorizationStatus.rawValue)")
            print("   Alert: \(settings.alertSetting.rawValue)")
            print("   Badge: \(settings.badgeSetting.rawValue)")
            print("   Sound: \(settings.soundSetting.rawValue)")
        }
    }
}
