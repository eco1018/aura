//
//
//
//
//
//
///
//
//  EnhancedSettingsView - Style 2 (Profile Header)
//
//  EnhancedSettingsView.swift
//  aura
//
//  Created by Assistant on 5/22/25.
//

import SwiftUI

struct EnhancedSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authVM: AuthViewModel
    @State private var showingDiaryHistory = false
    @State private var showingPersonalInfoEdit = false
    @State private var showingTrackingPreferencesEdit = false
    @State private var showingMedicationSettings = false
    @State private var showingNotificationSettings = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Header
                    profileHeader
                    
                    // Main Options with floating style
                    VStack(spacing: 12) {
                        // Diary History
                        FloatingSettingsCard(
                            icon: "chart.line.uptrend.xyaxis",
                            title: "Diary History",
                            subtitle: "View your past diary card submissions",
                            iconColor: .blue
                        ) {
                            showingDiaryHistory = true
                        }
                        
                        // Medications
                        FloatingSettingsCard(
                            icon: "pills",
                            title: "Medications",
                            subtitle: "Manage your medication list",
                            iconColor: .green
                        ) {
                            showingMedicationSettings = true
                        }
                        
                        // Notifications
                        FloatingSettingsCard(
                            icon: "bell",
                            title: "Notifications",
                            subtitle: "Manage reminders and alerts",
                            iconColor: .orange
                        ) {
                            showingNotificationSettings = true
                        }
                        
                        // Edit Personal Info
                        FloatingSettingsCard(
                            icon: "person.circle",
                            title: "Personal Information",
                            subtitle: "Update your name, age, and details",
                            iconColor: .purple
                        ) {
                            showingPersonalInfoEdit = true
                        }
                        
                        // Edit Tracking Preferences
                        FloatingSettingsCard(
                            icon: "slider.horizontal.3",
                            title: "Tracking Preferences",
                            subtitle: "Update your diary card preferences",
                            iconColor: .indigo
                        ) {
                            showingTrackingPreferencesEdit = true
                        }
                    }
                    
                    // Account Section
                    VStack(spacing: 16) {
                        HStack {
                            Text("Account")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        
                        // Sign Out
                        FloatingSettingsCard(
                            icon: "rectangle.portrait.and.arrow.right",
                            title: "Sign Out",
                            subtitle: "Sign out of your account",
                            iconColor: .red,
                            showChevron: false
                        ) {
                            authVM.signOut()
                            dismiss()
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .sheet(isPresented: $showingDiaryHistory) {
            DiaryHistoryView()
        }
        .sheet(isPresented: $showingMedicationSettings) {
            MedicationSettingsView()
                .environmentObject(authVM)
        }
        .sheet(isPresented: $showingNotificationSettings) {
            NotificationSettingsView()
                .environmentObject(authVM)
        }
        .sheet(isPresented: $showingPersonalInfoEdit) {
            PersonalInfoEditView()
                .environmentObject(authVM)
        }
        .sheet(isPresented: $showingTrackingPreferencesEdit) {
            TrackingPreferencesEditView()
                .environmentObject(authVM)
        }
    }
    
    private var profileHeader: some View {
        VStack(spacing: 16) {
            // Profile Image Circle
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.blue.opacity(0.8),
                            Color.purple.opacity(0.8)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 80, height: 80)
                .overlay(
                    Text(profileInitials)
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                )
            
            VStack(spacing: 4) {
                Text(authVM.userProfile?.name ?? "User")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text(authVM.userProfile?.email ?? "")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical)
    }
    
    private var profileInitials: String {
        let name = authVM.userProfile?.name ?? "U"
        let components = name.components(separatedBy: " ")
        if components.count >= 2 {
            let first = String(components[0].prefix(1))
            let last = String(components[1].prefix(1))
            return "\(first)\(last)".uppercased()
        } else {
            return String(name.prefix(2)).uppercased()
        }
    }
}

struct FloatingSettingsCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let iconColor: Color
    var showChevron: Bool = true
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Icon
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(iconColor)
                    .frame(width: 32, height: 32)
                
                // Content
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Chevron
                if showChevron {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .buttonStyle(PlainButtonStyle())
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)
                .shadow(color: .black.opacity(0.04), radius: 1, x: 0, y: 1)
        )
    }
}

#Preview {
    EnhancedSettingsView()
        .environmentObject(AuthViewModel.shared)
}
