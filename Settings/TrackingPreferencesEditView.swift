//
//
//
//  TrackingPreferencesEditView.swift
//  aura
//
//  Created by Assistant on 5/22/25.
//

import SwiftUI

struct TrackingPreferencesEditView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authVM: AuthViewModel
    @State private var currentSection: PreferenceSection = .actions
    @State private var isLoading = false
    @State private var showingSaveConfirmation = false
    
    // Edit states
    @State private var selectedActions: [String] = []
    @State private var customActions: [String] = []
    @State private var selectedUrges: [String] = []
    @State private var customUrges: [String] = []
    @State private var selectedGoals: [String] = []
    @State private var customGoals: [String] = []
    @State private var selectedEmotions: [String] = []
    @State private var morningReminderTime = Date()
    @State private var eveningReminderTime = Date()
    
    enum PreferenceSection: String, CaseIterable {
        case actions = "Actions"
        case urges = "Urges"
        case goals = "Goals"
        case emotions = "Emotions"
        case reminders = "Reminders"
        
        var icon: String {
            switch self {
            case .actions: return "exclamationmark.triangle"
            case .urges: return "flame"
            case .goals: return "target"
            case .emotions: return "heart"
            case .reminders: return "bell"
            }
        }
        
        var color: Color {
            switch self {
            case .actions: return .orange
            case .urges: return .red
            case .goals: return .purple
            case .emotions: return .pink
            case .reminders: return .green
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Section Picker
                sectionPicker
                
                // Content
                ScrollView {
                    VStack(spacing: 20) {
                        currentSectionView
                    }
                    .padding()
                }
                
                // Save Button
                saveButton
            }
            .navigationTitle("Tracking Preferences")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            loadCurrentPreferences()
        }
        .alert("Preferences Updated", isPresented: $showingSaveConfirmation) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Your tracking preferences have been successfully updated.")
        }
    }
    
    // MARK: - Section Picker
    private var sectionPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(PreferenceSection.allCases, id: \.self) { section in
                    Button(action: {
                        currentSection = section
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: section.icon)
                                .font(.caption)
                            
                            Text(section.rawValue)
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(currentSection == section ? section.color : Color(.systemGray5))
                        )
                        .foregroundColor(currentSection == section ? .white : .primary)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
    }
    
    // MARK: - Current Section View
    @ViewBuilder
    private var currentSectionView: some View {
        switch currentSection {
        case .actions:
            actionsSection
        case .urges:
            urgesSection
        case .goals:
            goalsSection
        case .emotions:
            emotionsSection
        case .reminders:
            remindersSection
        }
    }
    
    // MARK: - Actions Section
    private var actionsSection: some View {
        VStack(spacing: 16) {
            PreferenceCard(title: "Actions to Track", icon: "exclamationmark.triangle", iconColor: .orange) {
                VStack(spacing: 12) {
                    Text("Select up to 3 actions you want to track in your diary:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("Note: Self-harm and suicide are always tracked")
                        .font(.caption2)
                        .foregroundColor(.orange)
                        .italic()
                    
                    MultiSelectList(
                        items: availableActions,
                        selectedItems: $selectedActions,
                        customItems: $customActions,
                        maxSelection: 3,
                        placeholder: "Add custom action"
                    )
                }
            }
        }
    }
    
    // MARK: - Urges Section
    private var urgesSection: some View {
        PreferenceCard(title: "Urges to Track", icon: "flame", iconColor: .red) {
            VStack(spacing: 12) {
                Text("Select up to 2 urges you want to track in your diary:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("Note: Self-harm, suicide, and quit therapy urges are always tracked")
                    .font(.caption2)
                    .foregroundColor(.red)
                    .italic()
                
                MultiSelectList(
                    items: availableUrges,
                    selectedItems: $selectedUrges,
                    customItems: $customUrges,
                    maxSelection: 2,
                    placeholder: "Add custom urge"
                )
            }
        }
    }
    
    // MARK: - Goals Section
    private var goalsSection: some View {
        PreferenceCard(title: "Goals to Track", icon: "target", iconColor: .purple) {
            VStack(spacing: 12) {
                Text("Select up to 3 goals you want to track in your diary:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                MultiSelectList(
                    items: availableGoals,
                    selectedItems: $selectedGoals,
                    customItems: $customGoals,
                    maxSelection: 3,
                    placeholder: "Add custom goal"
                )
            }
        }
    }
    
    // MARK: - Emotions Section
    private var emotionsSection: some View {
        PreferenceCard(title: "Emotions to Track", icon: "heart", iconColor: .pink) {
            VStack(spacing: 12) {
                Text("Select up to 6 emotions you want to track in your diary:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 8) {
                    ForEach(availableEmotions, id: \.self) { emotion in
                        Button(action: {
                            toggleEmotionSelection(emotion)
                        }) {
                            Text(emotion)
                                .font(.caption)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(selectedEmotions.contains(emotion) ? Color.pink : Color(.systemGray5))
                                )
                                .foregroundColor(selectedEmotions.contains(emotion) ? .white : .primary)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
    }
    
    // MARK: - Reminders Section
    private var remindersSection: some View {
        PreferenceCard(title: "Diary Card Reminders", icon: "bell", iconColor: .green) {
            VStack(spacing: 20) {
                Text("Set times for your daily diary card reminders:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Morning Reminder")
                            .font(.headline)
                            .fontWeight(.medium)
                        
                        DatePicker(
                            "Morning Time",
                            selection: $morningReminderTime,
                            displayedComponents: .hourAndMinute
                        )
                        .datePickerStyle(CompactDatePickerStyle())
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Evening Reminder")
                            .font(.headline)
                            .fontWeight(.medium)
                        
                        DatePicker(
                            "Evening Time",
                            selection: $eveningReminderTime,
                            displayedComponents: .hourAndMinute
                        )
                        .datePickerStyle(CompactDatePickerStyle())
                    }
                }
            }
        }
    }
    
    // MARK: - Save Button
    private var saveButton: some View {
        Button(action: savePreferences) {
            HStack {
                if isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                        .foregroundColor(.white)
                }
                
                Text(isLoading ? "Saving..." : "Save Changes")
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .cornerRadius(12)
        }
        .disabled(isLoading)
        .padding()
        .background(Color(.systemBackground))
    }
    
    // MARK: - Helper Methods
    private func loadCurrentPreferences() {
        guard let profile = authVM.userProfile else { return }
        
        customActions = profile.customActions
        customUrges = profile.customUrges
        customGoals = profile.customGoals
        selectedEmotions = profile.selectedEmotions
        
        morningReminderTime = profile.morningReminderTime ?? Calendar.current.date(bySettingHour: 8, minute: 30, second: 0, of: Date()) ?? Date()
        eveningReminderTime = profile.eveningReminderTime ?? Calendar.current.date(bySettingHour: 20, minute: 0, second: 0, of: Date()) ?? Date()
    }
    
    private func toggleEmotionSelection(_ emotion: String) {
        if selectedEmotions.contains(emotion) {
            selectedEmotions.removeAll { $0 == emotion }
        } else if selectedEmotions.count < 6 {
            selectedEmotions.append(emotion)
        }
    }
    
    private func savePreferences() {
        guard let currentProfile = authVM.userProfile else { return }
        
        isLoading = true
        
        let updatedProfile = UserProfile(
            uid: currentProfile.uid,
            name: currentProfile.name,
            email: currentProfile.email,
            age: currentProfile.age,
            gender: currentProfile.gender,
            customActions: Array(Set(selectedActions + customActions)).prefix(3).map { $0 },
            customUrges: Array(Set(selectedUrges + customUrges)).prefix(2).map { $0 },
            customGoals: Array(Set(selectedGoals + customGoals)).prefix(3).map { $0 },
            selectedEmotions: selectedEmotions,
            morningReminderTime: morningReminderTime,
            eveningReminderTime: eveningReminderTime,
            hasCompletedOnboarding: true
        )
        
        updatedProfile.save { [self] success in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if success {
                    authVM.userProfile = updatedProfile
                    showingSaveConfirmation = true
                }
            }
        }
    }
    
    // MARK: - Data Sources
    private var availableActions: [String] {
        [
            "Substance Use",
            "Disordered Eating",
            "Lashing Out at Others",
            "Withdrawing from People",
            "Skipping Therapy or DBT Practice",
            "Risky Sexual Behavior",
            "Overspending or Impulsive Shopping",
            "Self-Neglect",
            "Avoiding Responsibilities",
            "Breaking Rules or the Law"
        ]
    }
    
    private var availableUrges: [String] {
        [
            "Substance Use",
            "Disordered Eating",
            "Shutting Down",
            "Breaking Things",
            "Impulsive Sex",
            "Impulsive Spending",
            "Ending Relationships",
            "Dropping Out"
        ]
    }
    
    private var availableGoals: [String] {
        [
            "Use DBT Skill",
            "Reach Out",
            "Follow Routine",
            "Nourish",
            "Move Body",
            "Get Out of Bed",
            "Self-Compassion",
            "Ask for Help",
            "Do For Me",
            "Align with Values"
        ]
    }
    
    private var availableEmotions: [String] {
        [
            "Happy", "Sad", "Angry", "Anxious", "Calm", "Frustrated",
            "Excited", "Scared", "Grateful", "Lonely", "Proud", "Ashamed",
            "Hopeful", "Overwhelmed", "Content", "Irritated", "Peaceful", "Confused"
        ]
    }
}

#Preview {
    TrackingPreferencesEditView()
        .environmentObject(AuthViewModel.shared)
}
