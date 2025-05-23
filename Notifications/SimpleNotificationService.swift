//
//  SimpleNotificationService.swift
//  aura
//
//  Created by Ella A. Sadduq on 5/23/25.
//


//
//  SimpleNotificationService.swift
//  aura
//
//  Simple notification service - start here, build out later
//

import Foundation
import UserNotifications

class SimpleNotificationService {
    static let shared = SimpleNotificationService()
    
    private init() {}
    
    // MARK: - Permission
    func requestPermission() async -> Bool {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound])
            print(granted ? "✅ Notifications allowed" : "❌ Notifications denied")
            return granted
        } catch {
            print("❌ Permission error: \(error)")
            return false
        }
    }
    
    // MARK: - Schedule Notifications
    func scheduleFromProfile(_ profile: UserProfile) {
        clearAll() // Start fresh each time
        
        // Medication reminders
        if profile.takesMedications {
            scheduleMedicationReminders(profile.medications)
        }
        
        // Diary reminders
        scheduleDiaryReminders(
            morning: profile.morningReminderTime,
            evening: profile.eveningReminderTime
        )
    }
    
    private func scheduleMedicationReminders(_ medications: [Medication]) {
        for medication in medications.filter(\.isActive) {
            for (index, time) in medication.reminderTimes.enumerated() {
                let id = "med_\(medication.rxcui)_\(index)"
                scheduleDaily(id: id, title: "Medication Reminder", body: "Time for your medication", time: time)
            }
        }
    }
    
    private func scheduleDiaryReminders(morning: Date?, evening: Date?) {
        if let morning = morning {
            scheduleDaily(id: "diary_morning", title: "Morning Check-in", body: "Time to check in with yourself", time: morning, isDiary: true)
        }
        
        if let evening = evening {
            scheduleDaily(id: "diary_evening", title: "Evening Reflection", body: "Time to reflect on your day", time: evening, isDiary: true)
        }
    }
    
    private func scheduleDaily(id: String, title: String, body: String, time: Date, isDiary: Bool = false) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        // Add deep link data only for diary notifications
        if isDiary {
            content.userInfo = ["openDiary": true, "session": id.contains("morning") ? "morning" : "evening"]
        }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
        
        print("📅 Scheduled: \(title) at \(components.hour ?? 0):\(String(format: "%02d", components.minute ?? 0))")
    }
    
    func clearAll() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}