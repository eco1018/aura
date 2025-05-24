//
//
//
//
//
// Enhanced SimpleNotificationService.swift - Fixed Deep Link Notifications
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
    
    // MARK: - Main Setup Method
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
        
        // Schedule new notifications
        scheduleMedicationReminders(for: profile)
        scheduleDiaryReminders(for: profile)
        
        print("✅ Notifications setup complete")
        
        // Debug: List what was scheduled
        await debugScheduledNotifications()
    }
    
    // MARK: - Medication Reminders
    private func scheduleMedicationReminders(for profile: UserProfile) {
        guard profile.takesMedications else {
            print("📋 Skipping medication reminders - user doesn't take medications")
            return
        }
        
        let activeMedications = profile.medications.filter { $0.isActive }
        print("💊 Scheduling reminders for \(activeMedications.count) active medications")
        
        for medication in activeMedications {
            for (index, reminderTime) in medication.reminderTimes.enumerated() {
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
                let components = calendar.dateComponents([.hour, .minute], from: reminderTime)
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                
                let request = UNNotificationRequest(
                    identifier: identifier,
                    content: content,
                    trigger: trigger
                )
                
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("❌ Failed to schedule medication reminder: \(error)")
                    } else {
                        print("📅 Scheduled medication reminder: \(medication.displayName) at \(formatTime(reminderTime))")
                    }
                }
            }
        }
    }
    
    // MARK: - Diary Card Reminders (ENHANCED)
    private func scheduleDiaryReminders(for profile: UserProfile) {
        print("📔 === SCHEDULING DIARY REMINDERS ===")
        
        // Morning reminder
        if let morningTime = profile.morningReminderTime {
            print("🌅 Scheduling morning reminder for: \(formatTime(morningTime))")
            scheduleDiaryReminder(
                identifier: "diary_morning",
                title: "Morning Check-in",
                body: "Good morning! Time to reflect on how you're feeling",
                time: morningTime,
                session: "morning"
            )
        } else {
            print("🌅 No morning reminder time set")
        }
        
        // Evening reminder
        if let eveningTime = profile.eveningReminderTime {
            print("🌙 Scheduling evening reminder for: \(formatTime(eveningTime))")
            scheduleDiaryReminder(
                identifier: "diary_evening",
                title: "Evening Reflection",
                body: "How was your day? Take a moment to check in with yourself",
                time: eveningTime,
                session: "evening"
            )
        } else {
            print("🌙 No evening reminder time set")
        }
        
        print("=== END DIARY REMINDERS ===")
    }
    
    private func scheduleDiaryReminder(identifier: String, title: String, body: String, time: Date, session: String) {
        print("📝 Creating diary reminder:")
        print("   - ID: \(identifier)")
        print("   - Title: \(title)")
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
        
        print("   - Trigger components: hour=\(components.hour ?? -1), minute=\(components.minute ?? -1)")
        
        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Failed to schedule diary reminder '\(identifier)': \(error)")
            } else {
                print("✅ Successfully scheduled diary reminder '\(identifier)' at \(formatTime(time))")
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
                
                print("   - UserInfo: \(content.userInfo)")
                
                let identifier = "test_diary_\(Date().timeIntervalSince1970)"
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("❌ Failed to schedule test diary notification: \(error)")
                    } else {
                        print("✅ Test diary notification scheduled for 5 seconds")
                        print("   - ID: \(identifier)")
                        print("   - Session: \(session)")
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
    
    func clearMedicationReminders() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let medicationIds = requests
                .filter { $0.identifier.starts(with: "medication_") }
                .map { $0.identifier }
            
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: medicationIds)
            print("🧹 Cleared \(medicationIds.count) medication reminders")
        }
    }
    
    func clearDiaryReminders() {
        let diaryIds = ["diary_morning", "diary_evening"]
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: diaryIds)
        print("🧹 Cleared diary reminders: \(diaryIds)")
    }
    
    // MARK: - Debug Methods (ENHANCED)
    func listScheduledNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            print("📋 === SCHEDULED NOTIFICATIONS (\(requests.count)) ===")
            for request in requests {
                let trigger = request.trigger
                let content = request.content
                
                print("   📌 \(request.identifier):")
                print("      Title: \(content.title)")
                print("      Body: \(content.body)")
                print("      UserInfo: \(content.userInfo)")
                
                if let calendarTrigger = trigger as? UNCalendarNotificationTrigger {
                    let time = calendarTrigger.dateComponents
                    print("      Time: \(time.hour ?? 0):\(String(format: "%02d", time.minute ?? 0)) (repeats: \(calendarTrigger.repeats))")
                } else if let intervalTrigger = trigger as? UNTimeIntervalNotificationTrigger {
                    print("      Interval: \(intervalTrigger.timeInterval)s (repeats: \(intervalTrigger.repeats))")
                }
                print("      ---")
            }
            print("=== END SCHEDULED NOTIFICATIONS ===")
        }
    }
    
    private func debugScheduledNotifications() async {
        return await withCheckedContinuation { continuation in
            UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
                print("🔍 Debug: \(requests.count) notifications scheduled after setup")
                
                let diaryNotifications = requests.filter { $0.identifier.starts(with: "diary_") }
                print("   - Diary notifications: \(diaryNotifications.count)")
                
                for diaryNotif in diaryNotifications {
                    print("     • \(diaryNotif.identifier): \(diaryNotif.content.userInfo)")
                }
                
                continuation.resume()
            }
        }
    }
}

// MARK: - Helper Functions
private func formatTime(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    return formatter.string(from: date)
}
