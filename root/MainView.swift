//
//
//
//
//
// Complete Updated MainView.swift - With All Debug Features
//
//
// Enhanced MainView.swift - Robust Deep Link Handling
//
//
// Fixed MainView.swift - Clean and Working
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var showingDiaryCard = false
    @State private var showingSettings = false
    @State private var diarySession: DiarySession = .manual
    
    // Track if we've processed a notification to avoid duplicates
    @State private var lastProcessedNotificationTime: Date = Date.distantPast
    
    var body: some View {
        NavigationView {
            ZStack {
                // Premium gradient background
                LinearGradient(
                    colors: [
                        Color(.systemGray6).opacity(0.1),
                        Color(.systemGray5).opacity(0.2),
                        Color(.systemGray6).opacity(0.15)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 60) {
                        // Elegant header
                        VStack(spacing: 20) {
                            Text("Hello, \(authVM.userProfile?.name ?? "Friend")")
                                .font(.system(size: 34, weight: .light, design: .default))
                                .foregroundColor(.primary.opacity(0.9))
                            
                            Text("How are you feeling today?")
                                .font(.system(size: 17, weight: .regular))
                                .foregroundColor(.secondary.opacity(0.7))
                        }
                        .padding(.top, 80)
                        
                        // Main Cards
                        VStack(spacing: 24) {
                            // Daily Diary Card
                            Button(action: {
                                diarySession = determineSession()
                                showingDiaryCard = true
                            }) {
                                mainCard(
                                    icon: "heart.text.square",
                                    title: "Daily Diary Card",
                                    subtitle: "Track your emotions and skills"
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            // Settings Card
                            Button(action: {
                                showingSettings = true
                            }) {
                                mainCard(
                                    icon: "gearshape",
                                    title: "Settings",
                                    subtitle: "Manage your preferences"
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            // DEBUG SECTION (only in DEBUG builds)
                            #if DEBUG
                            debugSection
                            #endif
                        }
                        .padding(.horizontal, 28)
                        
                        // Minimal date
                        Text("Today is \(Date(), style: .date)")
                            .font(.system(size: 14, weight: .light))
                            .foregroundColor(.secondary.opacity(0.5))
                            .padding(.bottom, 60)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingDiaryCard) {
            DiaryCardFlowView(session: diarySession)
        }
        .sheet(isPresented: $showingSettings) {
            EnhancedSettingsView()
                .environmentObject(authVM)
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("OpenDiaryCard"))) { notification in
            handleNotificationReceived(notification)
        }
        .onAppear {
            print("📱 MainView appeared")
            print("   - User: \(authVM.userProfile?.name ?? "nil")")
            print("   - showingDiaryCard: \(showingDiaryCard)")
        }
        .onChange(of: showingDiaryCard) { _, newValue in
            print("🔄 showingDiaryCard changed to: \(newValue)")
        }
    }
    
    // MARK: - View Components
    
    @ViewBuilder
    private func mainCard(icon: String, title: String, subtitle: String) -> some View {
        HStack(spacing: 20) {
            // Icon
            Image(systemName: icon)
                .font(.system(size: 28, weight: .light))
                .foregroundColor(.primary.opacity(0.8))
                .shadow(color: .primary.opacity(0.1), radius: 2, x: 1, y: 1)
                .shadow(color: .white.opacity(0.8), radius: 1, x: -0.5, y: -0.5)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.system(size: 19, weight: .medium))
                    .foregroundColor(.primary.opacity(0.9))
                
                Text(subtitle)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.secondary.opacity(0.6))
            }
            
            Spacer()
            
            Image(systemName: "arrow.right")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.secondary.opacity(0.4))
        }
        .padding(28)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(.systemBackground).opacity(0.8))
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.04), radius: 20, x: 0, y: 8)
                .shadow(color: .black.opacity(0.02), radius: 1, x: 0, y: 1)
        )
    }
    
    #if DEBUG
    @ViewBuilder
    private var debugSection: some View {
        VStack(spacing: 16) {
            Text("🧪 Debug Tools")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.secondary.opacity(0.8))
                .padding(.top, 20)
            
            // Test Diary Notification
            Button(action: {
                SimpleNotificationService.shared.testDiaryNotification(session: "evening")
            }) {
                debugCard(
                    icon: "bell.badge",
                    title: "Test Diary Notification",
                    subtitle: "Test deep link notification",
                    color: .orange
                )
            }
            .buttonStyle(PlainButtonStyle())
            
            // Debug Notifications State
            Button(action: {
                debugNotificationState()
            }) {
                debugCard(
                    icon: "magnifyingglass.circle",
                    title: "Debug Notifications",
                    subtitle: "Check scheduled notifications",
                    color: .blue
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    @ViewBuilder
    private func debugCard(icon: String, title: String, subtitle: String, color: Color) -> some View {
        HStack(spacing: 20) {
            Image(systemName: icon)
                .font(.system(size: 28, weight: .light))
                .foregroundColor(color.opacity(0.8))
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.system(size: 19, weight: .medium))
                    .foregroundColor(.primary.opacity(0.9))
                
                Text(subtitle)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.secondary.opacity(0.6))
            }
            
            Spacer()
        }
        .padding(28)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(.systemBackground).opacity(0.8))
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.04), radius: 20, x: 0, y: 8)
                .shadow(color: .black.opacity(0.02), radius: 1, x: 0, y: 1)
        )
    }
    #endif
    
    // MARK: - Helper Methods
    
    private func determineSession() -> DiarySession {
        let hour = Calendar.current.component(.hour, from: Date())
        
        // Morning: 5 AM - 12 PM
        if hour >= 5 && hour < 12 {
            return .morning
        }
        // Evening: 6 PM - 11 PM
        else if hour >= 18 && hour < 23 {
            return .evening
        }
        // Manual: All other times
        else {
            return .manual
        }
    }
    
    private func handleNotificationReceived(_ notification: Notification) {
        print("🎯 MainView received OpenDiaryCard notification:")
        print("   - UserInfo: \(notification.userInfo ?? [:])")
        
        // Prevent duplicate processing within 2 seconds
        let now = Date()
        if now.timeIntervalSince(lastProcessedNotificationTime) < 2.0 {
            print("⚠️ Ignoring duplicate notification within 2 seconds")
            return
        }
        
        lastProcessedNotificationTime = now
        
        guard let sessionString = notification.userInfo?["session"] as? String else {
            print("❌ No valid session found in notification userInfo")
            return
        }
        
        let session: DiarySession = sessionString == "morning" ? .morning :
                                  sessionString == "evening" ? .evening : .manual
        
        print("📔 Processing diary card notification:")
        print("   - Session string: \(sessionString)")
        print("   - Session enum: \(session)")
        
        // Ensure we're on the main thread with proper state handling
        DispatchQueue.main.async {
            if self.showingDiaryCard {
                // Close existing sheet first
                print("📱 Closing existing diary card to open new one")
                self.showingDiaryCard = false
                
                // Brief delay to allow sheet to close
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.diarySession = session
                    self.showingDiaryCard = true
                    print("✅ Reopened diary card with session: \(session)")
                }
            } else {
                // No existing sheet, open directly
                self.diarySession = session
                self.showingDiaryCard = true
                print("✅ Opened diary card with session: \(session)")
            }
        }
    }
    
    private func debugNotificationState() {
        print("🔍 === DEBUG: CHECKING NOTIFICATION STATE ===")
        
        // Check user profile reminder times
        if let profile = authVM.userProfile {
            print("👤 User Profile:")
            print("   - Name: \(profile.name)")
            print("   - Morning Reminder: \(profile.morningReminderTime?.formatted(date: .omitted, time: .shortened) ?? "❌ NONE")")
            print("   - Evening Reminder: \(profile.eveningReminderTime?.formatted(date: .omitted, time: .shortened) ?? "❌ NONE")")
            print("   - Has Completed Onboarding: \(profile.hasCompletedOnboarding)")
            print("   - Takes Medications: \(profile.takesMedications)")
            print("   - Active Medications: \(profile.activeMedications.count)")
        } else {
            print("❌ No user profile found!")
        }
        
        // Check scheduled notifications
        SimpleNotificationService.shared.listScheduledNotifications()
        
        // Check notification permissions
        Task {
            let status = await NotificationHelper.checkPermissionStatus()
            print("🔔 Notification Permission: \(status)")
        }
        
        print("=== END DEBUG INFO ===")
    }
}

#Preview {
    MainView()
        .environmentObject(AuthViewModel.shared)
}
