//
//
//
//
//
//
///
//
//
//
//
//
//
//
//
///
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
        VStack(spacing: 24) {
            // Header
            headerSection
            
            // Search Method Selection
            searchMethodSelector
            
            // Selected Medications
            if !selectedMedications.isEmpty {
                selectedMedicationsSection
            }
            
            // Add Medication Button
            addMedicationButton
            
            // Empty State or Help
            if selectedMedications.isEmpty {
                emptyStateView
            }
            
            Spacer()
            
            // Continue Button
            continueButton
        }
        .padding()
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
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 12) {
            Text("Add Your Medications")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            
            Text("Search from the National Library of Medicine database with detailed medication selection")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal)
    }
    
    // MARK: - Search Method Selector
    private var searchMethodSelector: some View {
        VStack(spacing: 12) {
            Text("Choose Search Method")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            
            HStack(spacing: 12) {
                // Enhanced Search Button
                Button(action: {
                    searchMethod = .enhanced
                }) {
                    VStack(spacing: 8) {
                        Image(systemName: "slider.horizontal.3")
                            .font(.title2)
                        
                        Text("Detailed")
                            .font(.caption)
                            .fontWeight(.medium)
                        
                        Text("Step-by-step")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(searchMethod == .enhanced ? Color.blue : Color(.systemGray6))
                    )
                    .foregroundColor(searchMethod == .enhanced ? .white : .primary)
                }
                .buttonStyle(PlainButtonStyle())
                
                // Basic Search Button
                Button(action: {
                    searchMethod = .basic
                }) {
                    VStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .font(.title2)
                        
                        Text("Quick")
                            .font(.caption)
                            .fontWeight(.medium)
                        
                        Text("Basic search")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(searchMethod == .basic ? Color.blue : Color(.systemGray6))
                    )
                    .foregroundColor(searchMethod == .basic ? .white : .primary)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    // MARK: - Selected Medications Section
    private var selectedMedicationsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Your Medications")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("\(selectedMedications.count) selected")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(4)
            }
            
            ForEach(selectedMedications) { medication in
                SelectedMedicationCard(medication: medication) {
                    removeMedication(medication)
                }
            }
        }
    }
    
    // MARK: - Add Medication Button
    private var addMedicationButton: some View {
        Button(action: {
            if searchMethod == .enhanced {
                showingMedicationBuilder = true
            } else {
                showingBasicSearch = true
            }
        }) {
            HStack {
                Image(systemName: "plus.circle.fill")
                    .font(.title3)
                
                Text(searchMethod == .enhanced ? "Add Medication (Detailed)" : "Add Medication (Quick)")
                    .font(.headline)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .cornerRadius(12)
        }
    }
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "pills.circle")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text("No Medications Added Yet")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 8) {
                if searchMethod == .enhanced {
                    Text("• **Detailed Search**: Step-by-step selection")
                    Text("• Choose exact formulation (XR, IR, etc.)")
                    Text("• Select precise strength and dosage")
                    Text("• Set custom reminder times")
                } else {
                    Text("• **Quick Search**: Fast medication lookup")
                    Text("• Basic medication information")
                    Text("• Faster for commonly known medications")
                }
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.leading)
        }
        .padding(.vertical, 20)
    }
    
    // MARK: - Continue Button
    private var continueButton: some View {
        Button(action: saveMedicationsAndContinue) {
            HStack {
                if selectedMedications.isEmpty {
                    Text("Skip - Add Later in Settings")
                } else {
                    Text("Continue with \(selectedMedications.count) medication\(selectedMedications.count == 1 ? "" : "s")")
                    Image(systemName: "checkmark.circle.fill")
                }
            }
            .foregroundColor(.white)
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.accentColor)
            .cornerRadius(12)
        }
    }
    
    // MARK: - Helper Methods
    private func addMedication(_ medication: Medication) {
        // Check if medication already exists (by rxcui)
        if !selectedMedications.contains(where: { $0.rxcui == medication.rxcui }) {
            selectedMedications.append(medication)
            print("✅ Added medication: \(medication.displayName)")
        }
    }
    
    private func removeMedication(_ medication: Medication) {
        selectedMedications.removeAll { $0.rxcui == medication.rxcui }
        print("🗑️ Removed medication: \(medication.displayName)")
    }
    
    private func saveMedicationsAndContinue() {
        // Save medications to onboarding view model
        onboardingVM.medications = selectedMedications
        onboardingVM.takesMedications = !selectedMedications.isEmpty
        
        print("💾 Saved \(selectedMedications.count) medications to onboarding")
        
        // Continue to next step
        onboardingVM.goToNextStep()
    }
}

// MARK: - Basic Search Sheet (Fallback)
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
        NavigationView {
            VStack(spacing: 20) {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search medications (quick search)", text: $searchText)
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
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                )
                .padding(.horizontal)
                
                // Results
                ScrollView {
                    LazyVStack(spacing: 12) {
                        // Selected medications
                        if !selectedMedications.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Selected (\(selectedMedications.count))")
                                    .font(.headline)
                                    .padding(.horizontal)
                                
                                ForEach(selectedMedications) { medication in
                                    SelectedMedicationCard(medication: medication) {
                                        removeMedication(medication)
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        
                        // Search results
                        if !searchResults.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Search Results")
                                    .font(.headline)
                                    .padding(.horizontal)
                                
                                ForEach(searchResults) { result in
                                    BasicSearchResultCard(
                                        result: result,
                                        isSelected: isSelected(result)
                                    ) {
                                        toggleSelection(result)
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        
                        // Empty state
                        if searchText.isEmpty && selectedMedications.isEmpty {
                            VStack(spacing: 16) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 40))
                                    .foregroundColor(.gray)
                                
                                Text("Quick Medication Search")
                                    .font(.headline)
                                
                                Text("Enter medication name for basic search")
                                    .font(.body)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 40)
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
        
        // Remove from search results to avoid confusion
        searchResults.removeAll { $0.rxcui == result.rxcui }
    }
    
    private func removeMedication(_ medication: Medication) {
        selectedMedications.removeAll { $0.rxcui == medication.rxcui }
    }
    
    private func isSelected(_ result: BasicMedicationSearchResult) -> Bool {
        selectedMedications.contains { $0.rxcui == result.rxcui }
    }
}

// MARK: - Supporting Card Views

struct SelectedMedicationCard: View {
    let medication: Medication
    let onRemove: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(medication.displayName)
                    .font(.body)
                    .fontWeight(.medium)
                
                HStack {
                    if let strength = medication.strength {
                        Text(strength)
                            .font(.caption)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(4)
                    }
                    
                    if let form = medication.dosageForm {
                        Text(form)
                            .font(.caption)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(4)
                    }
                    
                    Text(medication.frequency.displayName)
                        .font(.caption)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(4)
                }
                
                Text("RxCUI: \(medication.rxcui)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .opacity(0.7)
            }
            
            Spacer()
            
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title3)
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.green.opacity(0.1))
                .stroke(Color.green.opacity(0.3), lineWidth: 1)
        )
    }
}

struct BasicSearchResultCard: View {
    let result: BasicMedicationSearchResult
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(result.displayName)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    if let synonym = result.synonym, synonym != result.name {
                        Text("Also: \(synonym)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Text("RxCUI: \(result.rxcui)")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .opacity(0.7)
                }
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "plus.circle")
                    .font(.title3)
                    .foregroundColor(isSelected ? .green : .blue)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
                    .stroke(isSelected ? Color.green.opacity(0.5) : Color.clear, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    MedicationAddingView()
}
