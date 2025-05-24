//
//
//
//
//
//
//
//
//
// Enhanced SimpleNotificationService.swift - Fixed Deep Link Notifications
//

//
// Enhanced SimpleNotificationService.swift - Better Reliability & Error Handling
//

import Foundation
import UserNotifications

class SimpleNotificationService {
    static let shared = SimpleNotificationService()
    
    private init() {}
    
    // MARK: - Permission Management
    func requestPermission() async -> Bool {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(
                options: [.alert, .sound, .badge]
            )
            print(granted ? "✅ Notifications allowed" : "❌ Notifications denied")
            return granted
        } catch {
            print("❌ Permission error: \(error)")
            return false
        }
    }
    
    // MARK: - Main Setup Method with Verification
    func setupNotifications(for profile: UserProfile) async {
        print("🔔 === SETTING UP NOTIFICATIONS ===")
        print("   - User: \(profile.name)")
        print("   - Takes medications: \(profile.takesMedications)")
        print("   - Morning reminder: \(profile.morningReminderTime?.formatted(date: .omitted, time: .shortened) ?? "none")")
        print("   - Evening reminder: \(profile.eveningReminderTime?.formatted(date: .omitted, time: .shortened) ?? "none")")
        
        // Request permission first
        let hasPermission = await requestPermission()
        guard hasPermission else {
            print("⚠️ No notification permission, skipping setup")
            return
        }
        
        // Clear existing notifications
        clearAll()
        
        // Schedule new notifications with verification
        let medicationSuccess = await scheduleMedicationReminders(for: profile)
        let diarySuccess = await scheduleDiaryReminders(for: profile)
        
        print("✅ Notifications setup complete:")
        print("   - Medication reminders: \(medicationSuccess ? "✅" : "❌")")
        print("   - Diary reminders: \(diarySuccess ? "✅" : "❌")")
        
        // Verify what was actually scheduled
        await verifyScheduledNotifications()
    }
    
    // MARK: - Enhanced Medication Reminders with Async/Await
    private func scheduleMedicationReminders(for profile: UserProfile) async -> Bool {
        guard profile.takesMedications else {
            print("📋 Skipping medication reminders - user doesn't take medications")
            return true
        }
        
        let activeMedications = profile.medications.filter { $0.isActive }
        print("💊 Scheduling reminders for \(activeMedications.count) active medications")
        
        var allSuccessful = true
        
        for medication in activeMedications {
            for (index, reminderTime) in medication.reminderTimes.enumerated() {
                let success = await scheduleSingleMedicationReminder(
                    medication: medication,
                    time: reminderTime,
                    index: index
                )
                if !success {
                    allSuccessful = false
                }
            }
        }
        
        return allSuccessful
    }
    
    private func scheduleSingleMedicationReminder(medication: Medication, time: Date, index: Int) async -> Bool {
        let identifier = "medication_\(medication.rxcui)_\(index)"
        
        let content = UNMutableNotificationContent()
        content.title = "Medication Reminder"
        content.body = "Time to take your \(medication.displayName)"
        content.sound = .default
        content.badge = 1
        
        // Add medication-specific data
        content.userInfo = [
            "type": "medication",
            "medicationId": medication.rxcui,
            "medicationName": medication.displayName
        ]
        
        // Create daily repeating trigger
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger
        )
        
        return await withCheckedContinuation { continuation in
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("❌ Failed to schedule medication reminder: \(error)")
                    continuation.resume(returning: false)
                } else {
                    print("📅 Scheduled medication reminder: \(medication.displayName) at \(formatTime(time))")
                    continuation.resume(returning: true)
                }
            }
        }
    }
    
    // MARK: - Enhanced Diary Card Reminders with Async/Await
    private func scheduleDiaryReminders(for profile: UserProfile) async -> Bool {
        print("📔 === SCHEDULING DIARY REMINDERS ===")
        
        var allSuccessful = true
        
        // Morning reminder
        if let morningTime = profile.morningReminderTime {
            print("🌅 Scheduling morning reminder for: \(formatTime(morningTime))")
            let success = await scheduleSingleDiaryReminder(
                identifier: "diary_morning",
                title: "Morning Check-in",
                body: "Time to complete your morning diary card",
                time: morningTime,
                session: "morning"
            )
            if !success { allSuccessful = false }
        } else {
            print("🌅 No morning reminder time set")
        }
        
        // Evening reminder
        if let eveningTime = profile.eveningReminderTime {
            print("🌙 Scheduling evening reminder for: \(formatTime(eveningTime))")
            let success = await scheduleSingleDiaryReminder(
                identifier: "diary_evening",
                title: "Evening Reflection",
                body: "Time to complete your evening diary card",
                time: eveningTime,
                session: "evening"
            )
            if !success { allSuccessful = false }
        } else {
            print("🌙 No evening reminder time set")
        }
        
        print("=== END DIARY REMINDERS ===")
        return allSuccessful
    }
    
    private func scheduleSingleDiaryReminder(identifier: String, title: String, body: String, time: Date, session: String) async -> Bool {
        print("📝 Creating diary reminder:")
        print("   - ID: \(identifier)")
        print("   - Session: \(session)")
        print("   - Time: \(formatTime(time))")
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.badge = 1
        
        // CRITICAL: Ensure consistent userInfo format
        content.userInfo = [
            "type": "diary",
            "openDiary": true,
            "session": session,
            "action": "openDiaryCard"
        ]
        
        print("   - UserInfo: \(content.userInfo)")
        
        // Create daily repeating trigger
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        print("   - Trigger: hour=\(components.hour ?? -1), minute=\(components.minute ?? -1)")
        
        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger
        )
        
        return await withCheckedContinuation { continuation in
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("❌ Failed to schedule diary reminder '\(identifier)': \(error)")
                    continuation.resume(returning: false)
                } else {
                    print("✅ Successfully scheduled diary reminder '\(identifier)' at \(formatTime(time))")
                    continuation.resume(returning: true)
                }
            }
        }
    }
    
    // MARK: - Verification Method
    private func verifyScheduledNotifications() async {
        return await withCheckedContinuation { continuation in
            UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
                print("🔍 === NOTIFICATION VERIFICATION ===")
                print("   - Total scheduled: \(requests.count)")
                
                let diaryNotifications = requests.filter { $0.identifier.starts(with: "diary_") }
                let medicationNotifications = requests.filter { $0.identifier.starts(with: "medication_") }
                
                print("   - Diary notifications: \(diaryNotifications.count)")
                print("   - Medication notifications: \(medicationNotifications.count)")
                
                for notification in diaryNotifications {
                    print("     📔 \(notification.identifier): \(notification.content.userInfo)")
                }
                
                for notification in medicationNotifications {
                    print("     💊 \(notification.identifier): \(notification.content.title)")
                }
                
                print("=== END VERIFICATION ===")
                continuation.resume()
            }
        }
    }
    
    // MARK: - Test Method (ENHANCED)
    func testDiaryNotification(session: String = "evening") {
        print("🧪 === TESTING DIARY NOTIFICATION ===")
        print("   - Session: \(session)")
        
        Task {
            let hasPermission = await requestPermission()
            
            if hasPermission {
                let content = UNMutableNotificationContent()
                content.title = "🧪 Test: Diary Reminder"
                content.body = "Tap to open diary card (test)"
                content.sound = .default
                content.badge = 1
                
                // Match the exact format used in production
                content.userInfo = [
                    "type": "diary",
                    "openDiary": true,
                    "session": session,
                    "action": "openDiaryCard",
                    "isTest": true
                ]
                
                print("   - UserInfo: \(content.userInfo)")
                
                let identifier = "test_diary_\(Int(Date().timeIntervalSince1970))"
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("❌ Failed to schedule test diary notification: \(error)")
                    } else {
                        print("✅ Test diary notification scheduled for 5 seconds")
                        print("   - ID: \(identifier)")
                        print("   - Session: \(session)")
                        print("   - 🎯 TAP THE NOTIFICATION TO TEST DEEP LINK!")
                    }
                }
            } else {
                print("❌ No notification permission for test")
            }
        }
    }
    
    // MARK: - Utility Methods
    func clearAll() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        print("🧹 Cleared all notifications")
    }
    
    func listScheduledNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            print("📋 === SCHEDULED NOTIFICATIONS (\(requests.count)) ===")
            
            if requests.isEmpty {
                print("   ❌ No notifications currently scheduled!")
                return
            }
            
            for request in requests {
                let content = request.content
                
                print("   📌 \(request.identifier):")
                print("      Title: \(content.title)")
                print("      Body: \(content.body)")
                print("      UserInfo: \(content.userInfo)")
                
                if let calendarTrigger = request.trigger as? UNCalendarNotificationTrigger {
                    let time = calendarTrigger.dateComponents
                    print("      Time: \(time.hour ?? 0):\(String(format: "%02d", time.minute ?? 0)) (repeats: \(calendarTrigger.repeats))")
                } else if let intervalTrigger = request.trigger as? UNTimeIntervalNotificationTrigger {
                    print("      Interval: \(intervalTrigger.timeInterval)s (repeats: \(intervalTrigger.repeats))")
                }
                print("      ---")
            }
            print("=== END SCHEDULED NOTIFICATIONS ===")
        }
    }
}

// MARK: - Helper Functions
private func formatTime(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    return formatter.string(from: date)
}
