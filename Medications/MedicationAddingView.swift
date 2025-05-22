//
//
//
//
//
//  MedicationAddingView.swift
//  aura
//
//  Production-ready medication adding with real RxNorm API integration

import SwiftUI

struct MedicationAddingView: View {
    @ObservedObject var onboardingVM = OnboardingViewModel.shared
    @State private var searchText = ""
    @State private var searchResults: [MedicationSearchResult] = []
    @State private var selectedMedications: [Medication] = []
    @State private var isSearching = false
    @State private var searchTask: Task<Void, Never>?
    @State private var errorMessage: String = ""
    @State private var showingError = false
    @State private var showingRetry = false
    
    private let apiService = MedicationAPIServiceFactory.create()
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            headerSection
            
            // Search Interface
            searchSection
            
            // Content Area
            ScrollView {
                VStack(spacing: 16) {
                    // Selected Medications
                    if !selectedMedications.isEmpty {
                        selectedMedicationsSection
                    }
                    
                    // Search Results
                    if !searchResults.isEmpty {
                        searchResultsSection
                    }
                    
                    // Empty States
                    if searchText.isEmpty && selectedMedications.isEmpty {
                        emptyStateView
                    } else if !searchText.isEmpty && searchResults.isEmpty && !isSearching && !showingError {
                        noResultsView
                    }
                }
                .padding(.horizontal)
            }
            
            Spacer()
            
            // Continue Button
            continueButton
        }
        .padding(.vertical)
        .onChange(of: searchText) { _, newValue in
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
            VStack(alignment: .leading, spacing: 8) {
                Text(errorMessage)
                if let apiError = getLastError() as? MedicationAPIError {
                    Text(apiError.recoveryAdvice)
                        .font(.caption)
                }
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("Add Your Medications")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            
            Text("Search the National Library of Medicine database")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal)
    }
    
    // MARK: - Search Section
    private var searchSection: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search medications (e.g., aspirin, ibuprofen)", text: $searchText)
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
            
            // Search status
            if isSearching {
                HStack {
                    ProgressView()
                        .scaleEffect(0.7)
                    Text("Searching RxNorm database...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            } else if showingRetry {
                Button("Tap to retry search") {
                    performSearch()
                }
                .font(.caption)
                .foregroundColor(.blue)
            }
        }
    }
    
    // MARK: - Selected Medications Section
    private var selectedMedicationsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
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
    
    // MARK: - Search Results Section
    private var searchResultsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Search Results")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("RxNorm Database")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 1)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(3)
            }
            
            ForEach(searchResults) { result in
                SearchResultCard(
                    result: result,
                    isSelected: isAlreadySelected(result)
                ) {
                    if isAlreadySelected(result) {
                        removeMedicationByRxcui(result.rxcui)
                    } else {
                        addMedication(result)
                    }
                }
            }
        }
    }
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "pills.circle")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("Search for Your Medications")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 8) {
                Text("Access to 100,000+ medications from the")
                Text("National Library of Medicine RxNorm database")
                
                Text("Try searching for common medications:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.top, 8)
                
                HStack(spacing: 12) {
                    searchSuggestionButton("Aspirin")
                    searchSuggestionButton("Ibuprofen")
                    searchSuggestionButton("Metformin")
                }
            }
            .font(.body)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
        }
        .padding(.vertical, 40)
    }
    
    // MARK: - No Results View
    private var noResultsView: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 40))
                .foregroundColor(.gray)
            
            Text("No medications found")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 4) {
                Text("Try searching with:")
                Text("• Generic name (e.g., 'ibuprofen' not 'Advil')")
                Text("• Different spelling or abbreviation")
                Text("• Just the medication name without dosage")
            }
            .font(.body)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.leading)
        }
        .padding(.vertical, 30)
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
                        .font(.headline)
                }
            }
            .foregroundColor(.white)
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.accentColor)
            .cornerRadius(12)
        }
        .padding(.horizontal)
    }
    
    // MARK: - Helper Views
    private func searchSuggestionButton(_ text: String) -> some View {
        Button(text) {
            searchText = text
            performSearch()
        }
        .font(.caption)
        .foregroundColor(.blue)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.blue.opacity(0.1))
        .cornerRadius(6)
    }
    
    // MARK: - Helper Methods
    private func performDelayedSearch() {
        // Cancel previous search
        searchTask?.cancel()
        
        // Clear error state
        showingError = false
        showingRetry = false
        errorMessage = ""
        
        // Only search if there's meaningful input
        guard searchText.count >= 2 else {
            searchResults = []
            return
        }
        
        // Debounce search by 1 second for production API
        searchTask = Task {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            
            if !Task.isCancelled {
                await performSearch()
            }
        }
    }
    
    private func performSearch() {
        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else {
            searchResults = []
            return
        }
        
        Task {
            await MainActor.run {
                isSearching = true
                showingError = false
                showingRetry = false
                errorMessage = ""
            }
            
            do {
                let results = try await apiService.searchMedications(query: searchText)
                
                await MainActor.run {
                    self.searchResults = results
                    self.isSearching = false
                    
                    print("✅ RxNorm search completed: \(results.count) results")
                }
            } catch let error as MedicationAPIError {
                await MainActor.run {
                    handleSearchError(error)
                }
            } catch {
                await MainActor.run {
                    handleSearchError(.networkError)
                }
            }
        }
    }
    
    private func handleSearchError(_ error: MedicationAPIError) {
        print("❌ Medication search error: \(error)")
        
        searchResults = []
        isSearching = false
        errorMessage = error.localizedDescription
        
        switch error {
        case .rateLimited:
            showingRetry = true
            // Auto-retry after delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
                if showingRetry {
                    performSearch()
                }
            }
        case .networkError:
            showingError = true
        default:
            showingError = true
        }
    }
    
    private func addMedication(_ result: MedicationSearchResult) {
        let medication = result.toMedication()
        selectedMedications.append(medication)
        
        // Remove from search results to avoid confusion
        searchResults.removeAll { $0.rxcui == result.rxcui }
        
        print("✅ Added medication: \(medication.displayName)")
    }
    
    private func removeMedication(_ medication: Medication) {
        selectedMedications.removeAll { $0.rxcui == medication.rxcui }
        print("🗑️ Removed medication: \(medication.displayName)")
    }
    
    private func removeMedicationByRxcui(_ rxcui: String) {
        selectedMedications.removeAll { $0.rxcui == rxcui }
    }
    
    private func isAlreadySelected(_ result: MedicationSearchResult) -> Bool {
        return selectedMedications.contains { $0.rxcui == result.rxcui }
    }
    
    private func saveMedicationsAndContinue() {
        // Save medications to onboarding view model
        onboardingVM.medications = selectedMedications
        onboardingVM.takesMedications = !selectedMedications.isEmpty
        
        print("💾 Saved \(selectedMedications.count) medications to onboarding")
        
        // Continue to next step
        onboardingVM.goToNextStep()
    }
    
    private func getLastError() -> Error? {
        // This would ideally be stored in state, simplified for now
        return MedicationAPIError.networkError
    }
}

// MARK: - Supporting Card Views

private struct SelectedMedicationCard: View {
    let medication: Medication
    let onRemove: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(medication.displayName)
                    .font(.body)
                    .fontWeight(.medium)
                
                if let genericName = medication.genericName, genericName != medication.name {
                    Text("Generic: \(genericName)")
                        .font(.caption)
                        .foregroundColor(.secondary)
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

private struct SearchResultCard: View {
    let result: MedicationSearchResult
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
