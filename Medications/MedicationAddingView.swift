//
//
//
//
//
//
//
//
//  MedicationAddingView.swift
//  aura
//
//  Enhanced with multi-step medication selection flow

import SwiftUI

struct MedicationAddingView: View {
    @ObservedObject var onboardingVM = OnboardingViewModel.shared
    @State private var selectedMedications: [Medication] = []
    @State private var showingMedicationBuilder = false
    @State private var showingBasicSearch = false
    @State private var searchMethod: SearchMethod = .enhanced
    
    enum SearchMethod {
        case enhanced
        case basic
    }
    
    var body: some View {
        ZStack {
            // Premium gradient background (exact MainView match)
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
            
            VStack(spacing: 60) {
                // Header (exact MainView typography)
                VStack(spacing: 20) {
                    Text("Add Your Medications")
                        .font(.system(size: 34, weight: .light, design: .default))
                        .foregroundColor(.primary.opacity(0.9))
                    
                    Text("Search from the National Library of Medicine database with detailed medication selection")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.secondary.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 80)
                
                // Glassmorphic search method selector
                VStack(spacing: 24) {
                    Text("Choose Search Method")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.primary.opacity(0.9))
                    
                    HStack(spacing: 24) {
                        // Enhanced Search Card
                        Button(action: {
                            searchMethod = .enhanced
                        }) {
                            VStack(spacing: 12) {
                                Image(systemName: "slider.horizontal.3")
                                    .font(.system(size: 24, weight: .light))
                                    .foregroundColor(.primary.opacity(0.8))
                                    .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                                    .frame(width: 56, height: 56)
                                
                                VStack(spacing: 4) {
                                    Text("Detailed")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.primary.opacity(0.9))
                                    
                                    Text("Step-by-step")
                                        .font(.system(size: 13, weight: .regular))
                                        .foregroundColor(.secondary.opacity(0.6))
                                }
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color(.systemBackground).opacity(0.8))
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(searchMethod == .enhanced ? Color.primary.opacity(0.3) : Color.white.opacity(0.2), lineWidth: 1)
                                    )
                                    .shadow(color: .black.opacity(0.04), radius: 16, x: 0, y: 6)
                                    .shadow(color: .black.opacity(0.02), radius: 1, x: 0, y: 1)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        // Basic Search Card
                        Button(action: {
                            searchMethod = .basic
                        }) {
                            VStack(spacing: 12) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 24, weight: .light))
                                    .foregroundColor(.primary.opacity(0.8))
                                    .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                                    .frame(width: 56, height: 56)
                                
                                VStack(spacing: 4) {
                                    Text("Quick")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.primary.opacity(0.9))
                                    
                                    Text("Basic search")
                                        .font(.system(size: 13, weight: .regular))
                                        .foregroundColor(.secondary.opacity(0.6))
                                }
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color(.systemBackground).opacity(0.8))
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(searchMethod == .basic ? Color.primary.opacity(0.3) : Color.white.opacity(0.2), lineWidth: 1)
                                    )
                                    .shadow(color: .black.opacity(0.04), radius: 16, x: 0, y: 6)
                                    .shadow(color: .black.opacity(0.02), radius: 1, x: 0, y: 1)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 28)
                
                // Add Medication Button (glassmorphic style)
                Button(action: {
                    if searchMethod == .enhanced {
                        showingMedicationBuilder = true
                    } else {
                        showingBasicSearch = true
                    }
                }) {
                    HStack(spacing: 20) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24, weight: .light))
                            .foregroundColor(.primary.opacity(0.8))
                            .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                            .frame(width: 56, height: 56)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(searchMethod == .enhanced ? "Add Medication (Detailed)" : "Add Medication (Quick)")
                                .font(.system(size: 19, weight: .medium))
                                .foregroundColor(.primary.opacity(0.9))
                            
                            Text("Search medications from NLM database")
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
                .padding(.horizontal, 28)
                
                // Selected medications (if any)
                if !selectedMedications.isEmpty {
                    ScrollView {
                        VStack(spacing: 16) {
                            Text("Your Medications (\(selectedMedications.count))")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.primary.opacity(0.9))
                            
                            ForEach(selectedMedications) { medication in
                                SelectedMedicationCard(medication: medication) {
                                    removeMedication(medication)
                                }
                            }
                        }
                        .padding(.horizontal, 28)
                    }
                }
                
                Spacer()
                
                // Continue Button (exact MainView style)
                Button(action: saveMedicationsAndContinue) {
                    HStack(spacing: 12) {
                        if selectedMedications.isEmpty {
                            Text("Skip - Add Later in Settings")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white)
                        } else {
                            Text("Continue with \(selectedMedications.count) medication\(selectedMedications.count == 1 ? "" : "s")")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white)
                            
                            Image(systemName: "checkmark")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.primary.opacity(0.9))
                            .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 6)
                            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                    )
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 60)
            }
        }
        .onAppear {
            loadExistingMedications()
        }
        .onReceive(onboardingVM.$medications) { medications in
            if selectedMedications != medications {
                selectedMedications = medications
            }
        }
        .sheet(isPresented: $showingMedicationBuilder) {
            MedicationBuilderFlow { medication in
                addMedication(medication)
            }
        }
        .sheet(isPresented: $showingBasicSearch) {
            BasicMedicationSearchSheet { medications in
                for medication in medications {
                    addMedication(medication)
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func loadExistingMedications() {
        selectedMedications = onboardingVM.medications
        print("📦 Loaded \(selectedMedications.count) existing medications from onboarding")
    }
    
    private func addMedication(_ medication: Medication) {
        if !selectedMedications.contains(where: { $0.rxcui == medication.rxcui }) {
            selectedMedications.append(medication)
            syncWithOnboardingVM()
            print("✅ Added medication: \(medication.displayName)")
        } else {
            print("⚠️ Medication already exists: \(medication.displayName)")
        }
    }
    
    private func removeMedication(_ medication: Medication) {
        selectedMedications.removeAll { $0.rxcui == medication.rxcui }
        syncWithOnboardingVM()
        print("🗑️ Removed medication: \(medication.displayName)")
    }
    
    private func syncWithOnboardingVM() {
        onboardingVM.medications = selectedMedications
        onboardingVM.takesMedications = !selectedMedications.isEmpty
    }
    
    private func saveMedicationsAndContinue() {
        syncWithOnboardingVM()
        print("💾 Saved \(selectedMedications.count) medications to onboarding")
        for medication in selectedMedications {
            print("   - \(medication.displayName) (\(medication.rxcui))")
        }
        onboardingVM.goToNextStep()
    }
}

// MARK: - Supporting Card Views

struct SelectedMedicationCard: View {
    let medication: Medication
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(medication.displayName)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.primary.opacity(0.9))
                
                HStack(spacing: 8) {
                    if let strength = medication.strength {
                        Text(strength)
                            .font(.system(size: 12, weight: .regular))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.primary.opacity(0.1))
                            .cornerRadius(6)
                    }
                    
                    if let form = medication.dosageForm {
                        Text(form)
                            .font(.system(size: 12, weight: .regular))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(6)
                    }
                    
                    Text(medication.frequency.displayName)
                        .font(.system(size: 12, weight: .regular))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.secondary.opacity(0.15))
                        .cornerRadius(6)
                }
                
                Text("RxCUI: \(medication.rxcui)")
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(.secondary.opacity(0.6))
            }
            
            Spacer()
            
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 20, weight: .light))
                    .foregroundColor(.red.opacity(0.7))
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground).opacity(0.8))
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                .shadow(color: .black.opacity(0.03), radius: 8, x: 0, y: 4)
        )
    }
}

// MARK: - Basic Search Sheet (Fallback) - Enhanced to match design system

struct BasicMedicationSearchSheet: View {
    @Environment(\.dismiss) private var dismiss
    let onMedicationsSelected: ([Medication]) -> Void
    
    @State private var searchText = ""
    @State private var searchResults: [BasicMedicationSearchResult] = []
    @State private var selectedMedications: [Medication] = []
    @State private var isSearching = false
    @State private var errorMessage = ""
    @State private var showingError = false
    
    private let apiService = MedicationAPIServiceFactory.create()
    
    var body: some View {
        ZStack {
            // Same premium gradient background
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
            
            NavigationView {
                VStack(spacing: 24) {
                    // Glassmorphic search bar
                    HStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 18, weight: .light))
                            .foregroundColor(.secondary.opacity(0.6))
                        
                        TextField("Search medications", text: $searchText)
                            .font(.system(size: 16, weight: .regular))
                            .textInputAutocapitalization(.words)
                            .autocorrectionDisabled()
                            .onSubmit {
                                performSearch()
                            }
                        
                        if isSearching {
                            ProgressView()
                                .scaleEffect(0.8)
                        }
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemBackground).opacity(0.8))
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            .shadow(color: .black.opacity(0.03), radius: 8, x: 0, y: 4)
                    )
                    .padding(.horizontal, 20)
                    
                    // Results
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            if !selectedMedications.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Selected (\(selectedMedications.count))")
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(.primary.opacity(0.9))
                                        .padding(.horizontal, 20)
                                    
                                    ForEach(selectedMedications) { medication in
                                        SelectedMedicationCard(medication: medication) {
                                            removeMedication(medication)
                                        }
                                        .padding(.horizontal, 20)
                                    }
                                }
                            }
                            
                            if !searchResults.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Search Results")
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(.primary.opacity(0.9))
                                        .padding(.horizontal, 20)
                                    
                                    ForEach(searchResults) { result in
                                        BasicSearchResultCard(
                                            result: result,
                                            isSelected: isSelected(result)
                                        ) {
                                            toggleSelection(result)
                                        }
                                        .padding(.horizontal, 20)
                                    }
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Quick Search")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Add (\(selectedMedications.count))") {
                            onMedicationsSelected(selectedMedications)
                            dismiss()
                        }
                        .disabled(selectedMedications.isEmpty)
                        .fontWeight(.semibold)
                    }
                }
            }
        }
        .onChange(of: searchText) { _, _ in
            performDelayedSearch()
        }
        .alert("Search Error", isPresented: $showingError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
    
    @State private var searchTask: Task<Void, Never>?
    
    private func performDelayedSearch() {
        searchTask?.cancel()
        
        guard searchText.count >= 2 else {
            searchResults = []
            return
        }
        
        searchTask = Task {
            try? await Task.sleep(nanoseconds: 800_000_000)
            
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
                let results = try await apiService.searchMedications(query: searchText)
                
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
    
    private func toggleSelection(_ result: BasicMedicationSearchResult) {
        if isSelected(result) {
            selectedMedications.removeAll { $0.rxcui == result.rxcui }
        } else {
            selectedMedications.append(result.toMedication())
        }
        searchResults.removeAll { $0.rxcui == result.rxcui }
    }
    
    private func removeMedication(_ medication: Medication) {
        selectedMedications.removeAll { $0.rxcui == medication.rxcui }
    }
    
    private func isSelected(_ result: BasicMedicationSearchResult) -> Bool {
        selectedMedications.contains { $0.rxcui == result.rxcui }
    }
}

struct BasicSearchResultCard: View {
    let result: BasicMedicationSearchResult
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(result.displayName)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primary.opacity(0.9))
                    
                    if let synonym = result.synonym, synonym != result.name {
                        Text("Also: \(synonym)")
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(.secondary.opacity(0.7))
                    }
                    
                    Text("RxCUI: \(result.rxcui)")
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(.secondary.opacity(0.6))
                }
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "plus.circle")
                    .font(.system(size: 20, weight: .light))
                    .foregroundColor(isSelected ? .primary.opacity(0.8) : .secondary.opacity(0.6))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground).opacity(0.8))
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    .shadow(color: .black.opacity(0.02), radius: 4, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    MedicationAddingView()
}
