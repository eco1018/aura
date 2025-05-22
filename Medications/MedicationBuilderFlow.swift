//
//  MedicationBuilderFlow.swift
//  aura
//
//  Created by Ella A. Sadduq on 5/23/25.
//
//
//  MedicationBuilderFlow.swift
//  aura
//
//  Production-ready multi-step medication selection flow

import SwiftUI

// MARK: - Medication Selection Steps
enum MedicationSelectionStep: Int, CaseIterable {
    case searchName = 0
    case selectFormulation = 1
    case selectStrength = 2
    case setFrequency = 3
    case review = 4
    
    var title: String {
        switch self {
        case .searchName: return "Search Medication"
        case .selectFormulation: return "Choose Formulation"
        case .selectStrength: return "Select Strength"
        case .setFrequency: return "Set Frequency"
        case .review: return "Review & Confirm"
        }
    }
    
    var subtitle: String {
        switch self {
        case .searchName: return "Find your medication by name"
        case .selectFormulation: return "Choose the type (XR, IR, etc.)"
        case .selectStrength: return "Select the dosage strength"
        case .setFrequency: return "How often do you take it?"
        case .review: return "Confirm your medication details"
        }
    }
}

// MARK: - Medication Builder State
@MainActor
class MedicationBuilderState: ObservableObject {
    @Published var currentStep: MedicationSelectionStep = .searchName
    @Published var selectedName: MedicationName?
    @Published var selectedFormulation: MedicationFormulation?
    @Published var selectedStrength: MedicationStrengthOption?
    @Published var selectedFrequency: MedicationFrequency = .onceDaily
    @Published var reminderTimes: [Date] = []
    
    private let apiService = MedicationAPIServiceFactory.createEnhanced()
    
    func canProceedToNext() -> Bool {
        switch currentStep {
        case .searchName:
            return selectedName != nil
        case .selectFormulation:
            return selectedFormulation != nil
        case .selectStrength:
            return selectedStrength != nil
        case .setFrequency:
            return true // Frequency always has a default
        case .review:
            return true
        }
    }
    
    func nextStep() {
        guard canProceedToNext(),
              let nextStepRaw = currentStep.rawValue + 1,
              nextStepRaw < MedicationSelectionStep.allCases.count else { return }
        
        currentStep = MedicationSelectionStep(rawValue: nextStepRaw) ?? currentStep
        
        // Setup reminder times when frequency is selected
        if currentStep == .review {
            setupDefaultReminderTimes()
        }
    }
    
    func previousStep() {
        guard currentStep.rawValue > 0 else { return }
        currentStep = MedicationSelectionStep(rawValue: currentStep.rawValue - 1) ?? currentStep
    }
    
    func buildFinalMedication() -> Medication? {
        guard let name = selectedName,
              let formulation = selectedFormulation,
              let strength = selectedStrength else {
            return nil
        }
        
        var medication = Medication(
            rxcui: strength.rxcui,
            name: strength.brandName ?? name.name,
            genericName: name.isGeneric ? name.name : nil,
            strength: strength.strength,
            dosageForm: strength.dosageForm
        )
        
        medication.frequency = selectedFrequency
        medication.reminderTimes = reminderTimes
        
        return medication
    }
    
    private func setupDefaultReminderTimes() {
        let calendar = Calendar.current
        reminderTimes = []
        
        switch selectedFrequency {
        case .onceDaily:
            reminderTimes = [calendar.date(bySettingHour: 8, minute: 0, second: 0, of: Date()) ?? Date()]
        case .twiceDaily:
            reminderTimes = [
                calendar.date(bySettingHour: 8, minute: 0, second: 0, of: Date()) ?? Date(),
                calendar.date(bySettingHour: 20, minute: 0, second: 0, of: Date()) ?? Date()
            ]
        case .threeTimesDaily:
            reminderTimes = [
                calendar.date(bySettingHour: 8, minute: 0, second: 0, of: Date()) ?? Date(),
                calendar.date(bySettingHour: 14, minute: 0, second: 0, of: Date()) ?? Date(),
                calendar.date(bySettingHour: 20, minute: 0, second: 0, of: Date()) ?? Date()
            ]
        case .asNeeded:
            reminderTimes = []
        }
    }
}

// MARK: - Main Medication Builder Flow
struct MedicationBuilderFlow: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var builderState = MedicationBuilderState()
    let onComplete: (Medication) -> Void
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Progress indicator
                progressIndicator
                
                // Step content
                stepContent
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing),
                        removal: .move(edge: .leading)
                    ))
                
                // Navigation buttons
                navigationButtons
            }
            .navigationTitle(builderState.currentStep.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var progressIndicator: some View {
        VStack(spacing: 8) {
            // Progress bar
            ProgressView(value: Double(builderState.currentStep.rawValue + 1), total: Double(MedicationSelectionStep.allCases.count))
                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                .padding(.horizontal)
            
            // Step info
            VStack(spacing: 2) {
                Text("Step \(builderState.currentStep.rawValue + 1) of \(MedicationSelectionStep.allCases.count)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(builderState.currentStep.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.vertical, 16)
        .background(Color(.systemGroupedBackground))
    }
    
    @ViewBuilder
    private var stepContent: some View {
        switch builderState.currentStep {
        case .searchName:
            MedicationNameSearchView(builderState: builderState)
        case .selectFormulation:
            MedicationFormulationView(builderState: builderState)
        case .selectStrength:
            MedicationStrengthView(builderState: builderState)
        case .setFrequency:
            MedicationFrequencyView(builderState: builderState)
        case .review:
            MedicationReviewView(builderState: builderState)
        }
    }
    
    private var navigationButtons: some View {
        HStack(spacing: 16) {
            // Previous button
            if builderState.currentStep.rawValue > 0 {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        builderState.previousStep()
                    }
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Previous")
                    }
                    .foregroundColor(.blue)
                }
            } else {
                // Invisible spacer for layout
                Button("") { }
                    .hidden()
            }
            
            Spacer()
            
            // Next/Complete button
            Button(action: {
                if builderState.currentStep == .review {
                    // Complete the flow
                    if let medication = builderState.buildFinalMedication() {
                        onComplete(medication)
                        dismiss()
                    }
                } else {
                    // Go to next step
                    withAnimation(.easeInOut(duration: 0.3)) {
                        builderState.nextStep()
                    }
                }
            }) {
                HStack {
                    Text(builderState.currentStep == .review ? "Add Medication" : "Next")
                    if builderState.currentStep != .review {
                        Image(systemName: "chevron.right")
                    }
                }
                .foregroundColor(builderState.canProceedToNext() ? .blue : .gray)
            }
            .disabled(!builderState.canProceedToNext())
        }
        .padding()
        .background(Color(.systemBackground))
        .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: -1)
    }
}

// MARK: - Step 1: Name Search View
struct MedicationNameSearchView: View {
    @ObservedObject var builderState: MedicationBuilderState
    @State private var searchText = ""
    @State private var searchResults: [MedicationName] = []
    @State private var isSearching = false
    @State private var searchTask: Task<Void, Never>?
    @State private var errorMessage = ""
    @State private var showingError = false
    
    private let apiService = MedicationAPIServiceFactory.createEnhanced()
    
    var body: some View {
        VStack(spacing: 20) {
            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Enter medication name (e.g., Wellbutrin, Adderall)", text: $searchText)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()
                    .onSubmit {
                        performSearch()
                    }
                
                if isSearching {
                    ProgressView()
                        .scaleEffect(0.8)
                } else if !searchText.isEmpty {
                    Button("Clear") {
                        searchText = ""
                        searchResults = []
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
            )
            .padding(.horizontal)
            
            // Search results
            ScrollView {
                LazyVStack(spacing: 12) {
                    if !searchResults.isEmpty {
                        ForEach(searchResults) { medicationName in
                            MedicationNameCard(
                                medicationName: medicationName,
                                isSelected: builderState.selectedName?.rxcui == medicationName.rxcui
                            ) {
                                builderState.selectedName = medicationName
                            }
                        }
                    } else if searchText.isEmpty {
                        // Empty state
                        VStack(spacing: 16) {
                            Image(systemName: "pills.circle")
                                .font(.system(size: 60))
                                .foregroundColor(.gray)
                            
                            Text("Search for Your Medication")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Text("Type at least 2 characters to search the National Library of Medicine database")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.vertical, 40)
                    } else if !isSearching && !showingError {
                        // No results
                        VStack(spacing: 16) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)
                            
                            Text("No medications found")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Text("Try searching with the generic name or a different spelling")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.vertical, 30)
                    }
                }
                .padding(.horizontal)
            }
            
            Spacer()
        }
        .onChange(of: searchText) { _, _ in
            performDelayedSearch()
        }
        .onDisappear {
            searchTask?.cancel()
        }
        .alert("Search Error", isPresented: $showingError) {
            Button("Retry") {
                performSearch()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func performDelayedSearch() {
        searchTask?.cancel()
        
        guard searchText.count >= 2 else {
            searchResults = []
            return
        }
        
        searchTask = Task {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            
            if !Task.isCancelled {
                await performSearch()
            }
        }
    }
    
    private func performSearch() {
        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        Task {
            await MainActor.run {
                isSearching = true
                showingError = false
            }
            
            do {
                let results = try await apiService.searchMedicationNames(query: searchText)
                
                await MainActor.run {
                    self.searchResults = results
                    self.isSearching = false
                }
            } catch {
                await MainActor.run {
                    self.searchResults = []
                    self.isSearching = false
                    self.errorMessage = error.localizedDescription
                    self.showingError = true
                }
            }
        }
    }
}

// MARK: - Step 2: Formulation Selection
struct MedicationFormulationView: View {
    @ObservedObject var builderState: MedicationBuilderState
    @State private var formulations: [MedicationFormulation] = []
    @State private var isLoading = false
    @State private var errorMessage = ""
    @State private var showingError = false
    
    private let apiService = MedicationAPIServiceFactory.createEnhanced()
    
    var body: some View {
        VStack(spacing: 20) {
            // Selected medication info
            if let selectedName = builderState.selectedName {
                HStack {
                    Text("Selected: \(selectedName.displayName)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .padding(.horizontal)
            }
            
            if isLoading {
                VStack(spacing: 16) {
                    ProgressView()
                    Text("Loading formulations...")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(formulations) { formulation in
                            MedicationFormulationCard(
                                formulation: formulation,
                                isSelected: builderState.selectedFormulation?.rxcui == formulation.rxcui
                            ) {
                                builderState.selectedFormulation = formulation
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            Spacer()
        }
        .onAppear {
            loadFormulations()
        }
        .alert("Error Loading Formulations", isPresented: $showingError) {
            Button("Retry") {
                loadFormulations()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func loadFormulations() {
        guard let selectedName = builderState.selectedName else { return }
        
        Task {
            await MainActor.run {
                isLoading = true
                showingError = false
            }
            
            do {
                let results = try await apiService.getFormulations(for: selectedName)
                
                await MainActor.run {
                    self.formulations = results
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                    self.showingError = true
                }
            }
        }
    }
}

// MARK: - Step 3: Strength Selection
struct MedicationStrengthView: View {
    @ObservedObject var builderState: MedicationBuilderState
    @State private var strengths: [MedicationStrengthOption] = []
    @State private var isLoading = false
    @State private var errorMessage = ""
    @State private var showingError = false
    
    private let apiService = MedicationAPIServiceFactory.createEnhanced()
    
    var body: some View {
        VStack(spacing: 20) {
            // Selected info
            VStack(alignment: .leading, spacing: 8) {
                if let selectedName = builderState.selectedName {
                    HStack {
                        Text("Medication: \(selectedName.displayName)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                }
                
                if let selectedFormulation = builderState.selectedFormulation {
                    HStack {
                        Text("Type: \(selectedFormulation.displayName)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                }
            }
            .padding(.horizontal)
            
            if isLoading {
                VStack(spacing: 16) {
                    ProgressView()
                    Text("Loading strengths...")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(strengths) { strength in
                            MedicationStrengthCard(
                                strength: strength,
                                isSelected: builderState.selectedStrength?.rxcui == strength.rxcui
                            ) {
                                builderState.selectedStrength = strength
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            Spacer()
        }
        .onAppear {
            loadStrengths()
        }
        .alert("Error Loading Strengths", isPresented: $showingError) {
            Button("Retry") {
                loadStrengths()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func loadStrengths() {
        guard let selectedFormulation = builderState.selectedFormulation else { return }
        
        Task {
            await MainActor.run {
                isLoading = true
                showingError = false
            }
            
            do {
                let results = try await apiService.getStrengths(for: selectedFormulation)
                
                await MainActor.run {
                    self.strengths = results
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                    self.showingError = true
                }
            }
        }
    }
}

// MARK: - Step 4: Frequency Selection
struct MedicationFrequencyView: View {
    @ObservedObject var builderState: MedicationBuilderState
    
    var body: some View {
        VStack(spacing: 24) {
            // Instructions
            Text("How often do you take this medication?")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            // Frequency options
            VStack(spacing: 16) {
                ForEach(MedicationFrequency.allCases, id: \.self) { frequency in
                    FrequencyCard(
                        frequency: frequency,
                        isSelected: builderState.selectedFrequency == frequency
                    ) {
                        builderState.selectedFrequency = frequency
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding(.top)
    }
}

// MARK: - Step 5: Review
struct MedicationReviewView: View {
    @ObservedObject var builderState: MedicationBuilderState
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Medication summary
                VStack(alignment: .leading, spacing: 16) {
                    Text("Medication Summary")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    VStack(spacing: 12) {
                        ReviewRow(label: "Name", value: builderState.selectedName?.displayName ?? "")
                        ReviewRow(label: "Formulation", value: builderState.selectedFormulation?.displayName ?? "")
                        ReviewRow(label: "Strength", value: builderState.selectedStrength?.displayName ?? "")
                        ReviewRow(label: "Frequency", value: builderState.selectedFrequency.displayName)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                )
                
                // Reminder times
                if !builderState.reminderTimes.isEmpty {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Reminder Times")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        VStack(spacing: 8) {
                            ForEach(Array(builderState.reminderTimes.enumerated()), id: \.offset) { index, time in
                                HStack {
                                    Text(builderState.selectedFrequency.recommendedTimes[safe: index] ?? "Reminder \(index + 1)")
                                        .font(.body)
                                    
                                    Spacer()
                                    
                                    Text(time, style: .time)
                                        .font(.body)
                                        .fontWeight(.medium)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemGray6))
                    )
                }
                
                // Note
                Text("You can edit reminder times and other settings after adding the medication.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Spacer(minLength: 100)
            }
            .padding()
        }
    }
}

// MARK: - Supporting Card Views

struct MedicationNameCard: View {
    let medicationName: MedicationName
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(medicationName.displayName)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text("RxCUI: \(medicationName.rxcui)")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundColor(isSelected ? .green : .gray)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
                    .stroke(isSelected ? Color.green : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct MedicationFormulationCard: View {
    let formulation: MedicationFormulation
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(formulation.displayName)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text(formulation.name)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundColor(isSelected ? .green : .gray)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
                    .stroke(isSelected ? Color.green : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct MedicationStrengthCard: View {
    let strength: MedicationStrengthOption
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(strength.fullDisplayName)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text("RxCUI: \(strength.rxcui)")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundColor(isSelected ? .green : .gray)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
                    .stroke(isSelected ? Color.green : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct FrequencyCard: View {
    let frequency: MedicationFrequency
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(frequency.displayName)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    if !frequency.recommendedTimes.isEmpty {
                        Text("Suggested times: \(frequency.recommendedTimes.joined(separator: ", "))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundColor(isSelected ? .green : .gray)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
                    .stroke(isSelected ? Color.green : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ReviewRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.body)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.body)
                .fontWeight(.medium)
        }
    }
}

// MARK: - Array Extension for Safe Access
extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
