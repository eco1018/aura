//
//
//
//
//
// Complete Updated MainView.swift - With All Debug Features
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var showingDiaryCard = false
    @State private var showingSettings = false
    @State private var diarySession: DiarySession = .manual
    
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
                        
                        // Glassmorphic cards
                        VStack(spacing: 24) {
                            // Daily Diary Card - Premium glass effect
                            Button(action: {
                                diarySession = determineSession()
                                showingDiaryCard = true
                            }) {
                                HStack(spacing: 20) {
                                    // Elegant 3D icon
                                    Image(systemName: "heart.text.square")
                                        .font(.system(size: 28, weight: .light))
                                        .foregroundColor(.primary.opacity(0.8))
                                        .shadow(color: .primary.opacity(0.1), radius: 2, x: 1, y: 1)
                                        .shadow(color: .white.opacity(0.8), radius: 1, x: -0.5, y: -0.5)
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Daily Diary Card")
                                            .font(.system(size: 19, weight: .medium))
                                            .foregroundColor(.primary.opacity(0.9))
                                        
                                        Text("Track your emotions and skills")
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
                            .buttonStyle(PlainButtonStyle())
                            
                            // Settings Card - Matching glass effect
                            Button(action: {
                                showingSettings = true
                            }) {
                                HStack(spacing: 20) {
                                    // Elegant 3D icon
                                    Image(systemName: "gearshape")
                                        .font(.system(size: 28, weight: .light))
                                        .foregroundColor(.primary.opacity(0.8))
                                        .shadow(color: .primary.opacity(0.1), radius: 2, x: 1, y: 1)
                                        .shadow(color: .white.opacity(0.8), radius: 1, x: -0.5, y: -0.5)
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Settings")
                                            .font(.system(size: 19, weight: .medium))
                                            .foregroundColor(.primary.opacity(0.9))
                                        
                                        Text("Manage your preferences")
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
                            .buttonStyle(PlainButtonStyle())
                            
                            // DEBUG SECTION: Test and Debug Buttons (only in DEBUG builds)
                            #if DEBUG
                            VStack(spacing: 16) {
                                Text("🧪 Debug Tools")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.secondary.opacity(0.8))
                                    .padding(.top, 20)
                                
                                // Test Diary Notification Button
                                Button(action: {
                                    NotificationHelper.testDiaryNotification(session: "evening")
                                }) {
                                    HStack(spacing: 20) {
                                        Image(systemName: "bell.badge")
                                            .font(.system(size: 28, weight: .light))
                                            .foregroundColor(.orange.opacity(0.8))
                                        
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("Test Diary Notification")
                                                .font(.system(size: 19, weight: .medium))
                                                .foregroundColor(.primary.opacity(0.9))
                                            
                                            Text("Test deep link notification")
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
                                                    .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                                            )
                                            .shadow(color: .black.opacity(0.04), radius: 20, x: 0, y: 8)
                                            .shadow(color: .black.opacity(0.02), radius: 1, x: 0, y: 1)
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                // Debug Notifications State Button
                                Button(action: {
                                    print("🔍 === DEBUG: CHECKING NOTIFICATION STATE ===")
                                    
                                    // Check user profile reminder times
                                    if let profile = authVM.userProfile {
                                        print("👤 User Profile:")
                                        print("   - Name: \(profile.name)")
                                        print("   - Morning Reminder: \(profile.morningReminderTime?.formatted(date: .omitted, time: .shortened) ?? "❌ NONE")")
                                        print("   - Evening Reminder: \(profile.eveningReminderTime?.formatted(date: .omitted, time: .shortened) ?? "❌ NONE")")
                                        print("   - Has Completed Onboarding: \(profile.hasCompletedOnboarding)")
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
                                }) {
                                    HStack(spacing: 20) {
                                        Image(systemName: "magnifyingglass.circle")
                                            .font(.system(size: 28, weight: .light))
                                            .foregroundColor(.blue.opacity(0.8))
                                        
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("Debug Notifications")
                                                .font(.system(size: 19, weight: .medium))
                                                .foregroundColor(.primary.opacity(0.9))
                                            
                                            Text("Check scheduled notifications")
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
                                                    .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                            )
                                            .shadow(color: .black.opacity(0.04), radius: 20, x: 0, y: 8)
                                            .shadow(color: .black.opacity(0.02), radius: 1, x: 0, y: 1)
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                // Schedule Test Reminders Button (1 & 2 minutes from now)
                                Button(action: {
                                    print("🧪 Manually scheduling test notifications for near future...")
                                    
                                    guard let profile = authVM.userProfile else {
                                        print("❌ No user profile to schedule from")
                                        return
                                    }
                                    
                                    // Create a test profile with notifications 1 and 2 minutes from now
                                    let now = Date()
                                    let testMorningTime = Calendar.current.date(byAdding: .minute, value: 1, to: now)!
                                    let testEveningTime = Calendar.current.date(byAdding: .minute, value: 2, to: now)!
                                    
                                    var testProfile = profile
                                    testProfile.morningReminderTime = testMorningTime
                                    testProfile.eveningReminderTime = testEveningTime
                                    
                                    print("⏰ Scheduling test notifications:")
                                    print("   - Morning: \(testMorningTime.formatted(date: .omitted, time: .shortened))")
                                    print("   - Evening: \(testEveningTime.formatted(date: .omitted, time: .shortened))")
                                    
                                    Task {
                                        await SimpleNotificationService.shared.setupNotifications(for: testProfile)
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            SimpleNotificationService.shared.listScheduledNotifications()
                                        }
                                    }
                                    
                                }) {
                                    HStack(spacing: 20) {
                                        Image(systemName: "clock.badge.checkmark")
                                            .font(.system(size: 28, weight: .light))
                                            .foregroundColor(.green.opacity(0.8))
                                        
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("Schedule Test Reminders")
                                                .font(.system(size: 19, weight: .medium))
                                                .foregroundColor(.primary.opacity(0.9))
                                            
                                            Text("1 & 2 minutes from now")
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
                                                    .stroke(Color.green.opacity(0.3), lineWidth: 1)
                                            )
                                            .shadow(color: .black.opacity(0.04), radius: 20, x: 0, y: 8)
                                            .shadow(color: .black.opacity(0.02), radius: 1, x: 0, y: 1)
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                // Comprehensive Test Button
                                Button(action: {
                                    NotificationHelper.runComprehensiveTest()
                                }) {
                                    HStack(spacing: 20) {
                                        Image(systemName: "checkmark.seal")
                                            .font(.system(size: 28, weight: .light))
                                            .foregroundColor(.purple.opacity(0.8))
                                        
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("Run Full Test Suite")
                                                .font(.system(size: 19, weight: .medium))
                                                .foregroundColor(.primary.opacity(0.9))
                                            
                                            Text("Complete notification test")
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
                                                    .stroke(Color.purple.opacity(0.3), lineWidth: 1)
                                            )
                                            .shadow(color: .black.opacity(0.04), radius: 20, x: 0, y: 8)
                                            .shadow(color: .black.opacity(0.02), radius: 1, x: 0, y: 1)
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
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
        // FIXED: Better notification deep link handling with proper type conversion
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("OpenDiaryCard"))) { notification in
            print("🎯 MainView received OpenDiaryCard notification:")
            print("   - UserInfo: \(notification.userInfo ?? [:])")
            
            if let sessionString = notification.userInfo?["session"] as? String {
                let session: DiarySession = sessionString == "morning" ? .morning :
                                          sessionString == "evening" ? .evening : .manual
                
                print("📔 Opening diary card:")
                print("   - Session string: \(sessionString)")
                print("   - Session enum: \(session)")
                print("   - Current showingDiaryCard: \(showingDiaryCard)")
                
                // Ensure we're on the main thread and give a small delay
                DispatchQueue.main.async {
                    self.diarySession = session
                    self.showingDiaryCard = true
                    print("✅ Set showingDiaryCard = true for session: \(session)")
                }
            } else {
                print("❌ No valid session found in notification userInfo")
                // FIXED: Proper way to convert keys to array of strings
                if let userInfo = notification.userInfo {
                    let availableKeys = Array(userInfo.keys).map { String(describing: $0) }
                    print("   - Available keys: \(availableKeys)")
                } else {
                    print("   - UserInfo is nil")
                }
            }
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
}

#Preview {
    MainView()
        .environmentObject(AuthViewModel.shared)
}
