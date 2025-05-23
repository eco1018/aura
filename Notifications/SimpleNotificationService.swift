//
//
//
//  SimpleNotificationService.swift
//  aura
//
//  Created by Ella A. Sadduq on 5/23/25.
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
    }
    
    // MARK: - Medication Reminders
    private func scheduleMedicationReminders(for profile: UserProfile) {
        guard profile.takesMedications else { return }
        
        let activeMedications = profile.medications.filter { $0.isActive }
        
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
    
    // MARK: - Diary Card Reminders
    private func scheduleDiaryReminders(for profile: UserProfile) {
        // Morning reminder
        if let morningTime = profile.morningReminderTime {
            scheduleDiaryReminder(
                identifier: "diary_morning",
                title: "Morning Check-in",
                body: "Good morning! Time to reflect on how you're feeling",
                time: morningTime,
                session: "morning"
            )
        }
        
        // Evening reminder
        if let eveningTime = profile.eveningReminderTime {
            scheduleDiaryReminder(
                identifier: "diary_evening",
                title: "Evening Reflection",
                body: "How was your day? Take a moment to check in with yourself",
                time: eveningTime,
                session: "evening"
            )
        }
    }
    
    private func scheduleDiaryReminder(identifier: String, title: String, body: String, time: Date, session: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.badge = 1
        
        // Add diary-specific data for deep linking
        content.userInfo = [
            "type": "diary",
            "openDiary": true,
            "session": session
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
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Failed to schedule diary reminder: \(error)")
            } else {
                print("📅 Scheduled diary reminder: \(title) at \(formatTime(time))")
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
            print("🧹 Cleared medication reminders")
        }
    }
    
    func clearDiaryReminders() {
        let diaryIds = ["diary_morning", "diary_evening"]
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: diaryIds)
        print("🧹 Cleared diary reminders")
    }
    
    // MARK: - Debug Methods
    func listScheduledNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            print("📋 Scheduled notifications (\(requests.count)):")
            for request in requests {
                let trigger = request.trigger as? UNCalendarNotificationTrigger
                let time = trigger?.dateComponents
                print("   - \(request.identifier): \(request.content.title) at \(time?.hour ?? 0):\(String(format: "%02d", time?.minute ?? 0))")
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
