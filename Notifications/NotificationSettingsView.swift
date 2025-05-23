//
//  NotificationSettingsView.swift
//  aura
//
//  Created by Ella A. Sadduq on 5/23/25.
//


//
//  NotificationSettingsView.swift
//  aura
//
//  Created by Ella A. Sadduq on 5/23/25.
//

import SwiftUI
import UserNotifications

struct NotificationSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authVM: AuthViewModel
    @State private var isLoading = false
    @State private var notificationStatus = "Unknown"
    @State private var scheduledCount = 0
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Image(systemName: "bell.fill")
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Notification Status")
                                .font(.body)
                                .fontWeight(.medium)
                            
                            Text(notificationStatus)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        if isLoading {
                            ProgressView()
                                .scaleEffect(0.8)
                        }
                    }
                } header: {
                    Text("Status")
                }
                
                Section {
                    Text("\(scheduledCount) notifications scheduled")
                        .font(.body)
                        .foregroundColor(.secondary)
                } header: {
                    Text("Scheduled Reminders")
                }
                
                Section {
                    Button("Request Permission") {
                        requestNotificationPermission()
                    }
                    .disabled(notificationStatus == "Authorized")
                    
                    Button("Refresh Notifications") {
                        refreshNotifications()
                    }
                    
                    Button("Test Notification") {
                        sendTestNotification()
                    }
                } header: {
                    Text("Actions")
                }
                
                Section {
                    Button("Clear All Notifications", role: .destructive) {
                        clearAllNotifications()
                    }
                    
                    Button("View Scheduled", action: listScheduledNotifications)
                } header: {
                    Text("Debug")
                }
            }
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            checkNotificationStatus()
            getScheduledCount()
        }
    }
    
    // MARK: - Methods
    
    private func checkNotificationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .authorized:
                    notificationStatus = "Authorized"
                case .denied:
                    notificationStatus = "Denied"
                case .notDetermined:
                    notificationStatus = "Not Determined"
                case .provisional:
                    notificationStatus = "Provisional"
                case .ephemeral:
                    notificationStatus = "Ephemeral"
                @unknown default:
                    notificationStatus = "Unknown"
                }
            }
        }
    }
    
    private func getScheduledCount() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            DispatchQueue.main.async {
                scheduledCount = requests.count
            }
        }
    }
    
    private func requestNotificationPermission() {
        isLoading = true
        
        Task {
            let granted = await SimpleNotificationService.shared.requestPermission()
            
            DispatchQueue.main.async {
                isLoading = false
                checkNotificationStatus()
                
                if granted, let profile = authVM.userProfile {
                    refreshNotifications()
                }
            }
        }
    }
    
    private func refreshNotifications() {
        guard let profile = authVM.userProfile else { return }
        
        isLoading = true
        
        Task {
            await SimpleNotificationService.shared.setupNotifications(for: profile)
            
            DispatchQueue.main.async {
                isLoading = false
                getScheduledCount()
            }
        }
    }
    
    private func sendTestNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Test Notification"
        content.body = "This is a test notification from Aura"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "test", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    private func clearAllNotifications() {
        SimpleNotificationService.shared.clearAll()
        getScheduledCount()
    }
    
    private func listScheduledNotifications() {
        SimpleNotificationService.shared.listScheduledNotifications()
    }
}

#Preview {
    NotificationSettingsView()
        .environmentObject(AuthViewModel.shared)
}