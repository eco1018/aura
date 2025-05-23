//
//  NotificationHelper.swift
//  aura
//
//  NotificationHelper.swift
//  aura
//
//  Created by Ella A. Sadduq on 5/23/25.
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
}
