//
//
//  DiaryCardFlowView.swift
//  aura
//
//  Created by Ella A. Sadduq on 5/22/25.
//

import SwiftUI

struct DiaryCardFlowView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var diaryEntry: DiaryEntryViewModel
    @State private var currentStep: DiaryStep = .actions
    @State private var showingSaveConfirmation = false
    
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
                        dismiss()
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
    
    private func saveEntry() {
        print("💾 Saving diary entry...")
        diaryEntry.saveEntry { success in
            if success {
                showingSaveConfirmation = true
                print("✅ Diary entry saved successfully!")
            } else {
                print("❌ Failed to save diary entry")
            }
        }
    }
}

// MARK: - Placeholder Step View
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

#Preview {
    DiaryCardFlowView(session: .manual)
}
