//
//
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
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Header
                    profileHeader
                    
                    // Main Options
                    VStack(spacing: 16) {
                        // Diary History
                        SettingsOptionCard(
                            icon: "chart.line.uptrend.xyaxis",
                            title: "Diary History",
                            subtitle: "View your past diary card submissions",
                            iconColor: .blue
                        ) {
                            showingDiaryHistory = true
                        }
                        
                        // Edit Personal Info
                        SettingsOptionCard(
                            icon: "person.circle",
                            title: "Personal Information",
                            subtitle: "Update your name, age, and details",
                            iconColor: .green
                        ) {
                            showingPersonalInfoEdit = true
                        }
                        
                        // Edit Tracking Preferences
                        SettingsOptionCard(
                            icon: "slider.horizontal.3",
                            title: "Tracking Preferences",
                            subtitle: "Update your diary card preferences",
                            iconColor: .purple
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
                        .padding(.horizontal)
                        
                        // Sign Out
                        SettingsOptionCard(
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
                .padding()
            }
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

struct SettingsOptionCard: View {
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
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    EnhancedSettingsView()
        .environmentObject(AuthViewModel.shared)
}
