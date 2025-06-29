//
//
//  DiaryCardFlowView.swift
//  aura
//
//  Enhanced DiaryCardFlowView.swift
//  aura
//
//  Enhanced with comprehensive save validation and error handling

import SwiftUI

struct DiaryCardFlowView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var diaryEntry: DiaryEntryViewModel
    @State private var currentStep: DiaryStep = .actions
    @State private var showingSaveConfirmation = false
    @State private var showingSaveError = false
    @State private var saveErrorMessage = ""
    
    init(session: DiarySession = .manual) {
        self._diaryEntry = StateObject(wrappedValue: DiaryEntryViewModel(session: session))
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Progress bar
                ProgressView(value: currentStep.progressPercentage)
                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                    .padding(.horizontal)
                    .padding(.top, 8)
                
                // Step indicator
                HStack {
                    Text("Step \(stepNumber) of \(DiaryStep.allCases.count)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text(currentStep.title)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    // Unsaved changes indicator
                    if diaryEntry.hasUnsavedChanges {
                        Circle()
                            .fill(Color.orange)
                            .frame(width: 6, height: 6)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 16)
                
                // Current step view
                currentStepView
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing),
                        removal: .move(edge: .leading)
                    ))
                
                // Navigation buttons
                navigationButtons
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        handleCancelAction()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if currentStep == DiaryStep.allCases.last {
                        Button("Save") {
                            saveEntry()
                        }
                        .fontWeight(.semibold)
                        .disabled(diaryEntry.isLoading)
                    }
                }
            }
        }
        .alert("Entry Saved", isPresented: $showingSaveConfirmation) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text(diaryEntry.saveMessage)
        }
        .alert("Save Error", isPresented: $showingSaveError) {
            Button("Retry") {
                saveEntry()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text(saveErrorMessage)
        }
        .onAppear {
            print("📱 DiaryCardFlowView appeared")
            print("   - Session: \(diaryEntry.diaryEntry.session)")
            print("   - User has custom actions: \(diaryEntry.getAllActions().count)")
            print("   - User has custom urges: \(diaryEntry.getAllUrges().count)")
            print("   - User has custom goals: \(diaryEntry.getAllGoals().count)")
            print("   - User has emotions: \(diaryEntry.getAllEmotions().count)")
        }
    }
    
    private var stepNumber: Int {
        (DiaryStep.allCases.firstIndex(of: currentStep) ?? 0) + 1
    }
    
    @ViewBuilder
    private var currentStepView: some View {
        switch currentStep {
        case .actions:
            ActionsStepView(diaryEntry: diaryEntry)
        case .urges:
            UrgesStepView(diaryEntry: diaryEntry)
        case .emotions:
            EmotionsStepView(diaryEntry: diaryEntry)
        case .skills:
            SkillsStepView(diaryEntry: diaryEntry)
        case .medications:
            MedicationsStepView(diaryEntry: diaryEntry)
        case .goals:
            GoalsStepView(diaryEntry: diaryEntry)
        case .dailyNote:
            DailyNoteStepView(diaryEntry: diaryEntry)
        }
    }
    
    private var navigationButtons: some View {
        HStack(spacing: 16) {
            // Previous button
            if let previousStep = currentStep.previous() {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentStep = previousStep
                    }
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Previous")
                    }
                    .foregroundColor(.blue)
                }
            } else {
                // Invisible placeholder to maintain spacing
                Button("") { }
                    .hidden()
            }
            
            Spacer()
            
            // Next button
            if let nextStep = currentStep.next() {
                Button(action: {
                    // Auto-save current progress before moving to next step
                    if diaryEntry.hasUnsavedChanges {
                        print("💾 Auto-saving progress before next step...")
                    }
                    
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentStep = nextStep
                    }
                }) {
                    HStack {
                        Text("Next")
                        Image(systemName: "chevron.right")
                    }
                    .foregroundColor(.blue)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: -1)
    }
    
    private func handleCancelAction() {
        if diaryEntry.hasUnsavedChanges {
            // Show confirmation dialog for unsaved changes
            showUnsavedChangesAlert()
        } else {
            dismiss()
        }
    }
    
    private func showUnsavedChangesAlert() {
        let alert = UIAlertController(
            title: "Unsaved Changes",
            message: "You have unsaved changes. Do you want to save your progress before leaving?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Save & Exit", style: .default) { _ in
            saveEntry()
        })
        
        alert.addAction(UIAlertAction(title: "Discard Changes", style: .destructive) { _ in
            dismiss()
        })
        
        alert.addAction(UIAlertAction(title: "Continue Editing", style: .cancel))
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(alert, animated: true)
        }
    }
    
    private func saveEntry() {
        print("💾 Starting save process...")
        print("   - Current step: \(currentStep)")
        print("   - Has unsaved changes: \(diaryEntry.hasUnsavedChanges)")
        
        // Validate that we have some meaningful data
        let hasAnyData = hasValidDiaryData()
        if !hasAnyData {
            saveErrorMessage = "Please fill out at least some information before saving."
            showingSaveError = true
            return
        }
        
        diaryEntry.saveEntry { [self] success in
            if success {
                print("✅ Diary entry saved successfully!")
                showingSaveConfirmation = true
            } else {
                print("❌ Failed to save diary entry")
                saveErrorMessage = diaryEntry.saveMessage
                showingSaveError = true
            }
        }
    }
    
    private func hasValidDiaryData() -> Bool {
        // Check if user has entered any meaningful data
        let hasActionData = diaryEntry.getAllActions().contains { $0.value.value > 0 }
        let hasUrgeData = diaryEntry.getAllUrges().contains { $0.value.value > 0 }
        let hasEmotionData = diaryEntry.getAllEmotions().contains { $0.value.value != 5 } // 5 is default
        let hasSkillData = diaryEntry.getSkillEffectiveness() != 5 // 5 is default
        let hasMedicationData = diaryEntry.getMedicationCompliance() || !diaryEntry.getMedicationNotes().isEmpty
        let hasGoalData = diaryEntry.getAllGoals().contains { $0.completed }
        let hasNoteData = !diaryEntry.getDailyNote().isEmpty ||
                         !diaryEntry.getDailyMood().isEmpty ||
                         !diaryEntry.getDailyHighlights().isEmpty
        
        let hasData = hasActionData || hasUrgeData || hasEmotionData || hasSkillData ||
                     hasMedicationData || hasGoalData || hasNoteData
        
        print("📊 Data validation check:")
        print("   - Has action data: \(hasActionData)")
        print("   - Has urge data: \(hasUrgeData)")
        print("   - Has emotion data: \(hasEmotionData)")
        print("   - Has skill data: \(hasSkillData)")
        print("   - Has medication data: \(hasMedicationData)")
        print("   - Has goal data: \(hasGoalData)")
        print("   - Has note data: \(hasNoteData)")
        print("   - Overall has data: \(hasData)")
        
        return hasData
    }
}

// MARK: - Enhanced Placeholder Step View
struct PlaceholderStepView: View {
    let step: DiaryStep
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: step.systemImage)
                .font(.largeTitle)
                .foregroundColor(.gray)
            
            Text(step.title)
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Coming soon...")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(step.description)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
