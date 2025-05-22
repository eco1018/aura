//
//
//
//
//  MedicationAddingView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/29/25.
//

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
    
    private let apiService = MedicationAPIServiceFactory.create()
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 8) {
                Text("Add Your Medications")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                
                Text("Search our comprehensive medication database")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal)
            
            // Search Bar
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search medications...", text: $searchText)
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
                
                // Search hint
                if searchText.isEmpty && searchResults.isEmpty && selectedMedications.isEmpty {
                    VStack(spacing: 4) {
                        Text("Try searching for:")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            Text("\"Aspirin\"")
                            Text("\"Ibuprofen\"")
                            Text("\"Metformin\"")
                        }
                        .font(.caption)
                        .foregroundColor(.blue)
                        .italic()
                    }
                }
                
                // Error message
                if showingError {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
            }
            
            // Content Area
            ScrollView {
                VStack(spacing: 16) {
                    // Selected Medications Section
                    if !selectedMedications.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Your Medications")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                
                                Spacer()
                                
                                Text("\(selectedMedications.count) selected")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            ForEach(selectedMedications) { medication in
                                MedicationCard(medication: medication, isSelected: true) {
                                    removeMedication(medication)
                                }
                            }
                        }
                    }
                    
                    // Search Results Section
                    if !searchResults.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Search Results")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                
                                Spacer()
                                
                                Text("from RxNorm database")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            ForEach(searchResults) { result in
                                SearchCard(
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
                    
                    // Empty state
                    if searchText.isEmpty && selectedMedications.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "pills.circle")
                                .font(.system(size: 60))
                                .foregroundColor(.gray)
                            
                            Text("Search the RxNorm Database")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Text("Access to 100,000+ medications from the National Library of Medicine. Start typing to search.")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .padding(.vertical, 40)
                    }
                    
                    // No results state
                    if !searchText.isEmpty && searchResults.isEmpty && !isSearching && !showingError {
                        VStack(spacing: 16) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)
                            
                            Text("No medications found")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Text("Try searching with a different spelling or generic name")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .padding(.vertical, 30)
                    }
                }
                .padding(.horizontal)
            }
            
            Spacer()
            
            // Continue Button
            Button(action: {
                saveMedicationsAndContinue()
            }) {
                HStack {
                    Text(selectedMedications.isEmpty ? "Skip" : "Continue with \(selectedMedications.count) medication\(selectedMedications.count == 1 ? "" : "s")")
                        .font(.headline)
                    
                    if !selectedMedications.isEmpty {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.headline)
                    }
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentColor)
                .cornerRadius(12)
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
        .onChange(of: searchText) { _, newValue in
            performDelayedSearch()
        }
        .onDisappear {
            searchTask?.cancel()
        }
    }
    
    // MARK: - Helper Methods
    private func performDelayedSearch() {
        // Cancel previous search
        searchTask?.cancel()
        
        // Clear error state
        showingError = false
        errorMessage = ""
        
        // Only search if there's meaningful input
        guard searchText.count >= 2 else {
            searchResults = []
            return
        }
        
        // Debounce search by 800ms for real API
        searchTask = Task {
            try? await Task.sleep(nanoseconds: 800_000_000)
            
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
                errorMessage = ""
            }
            
            do {
                let results = try await apiService.searchMedications(query: searchText)
                
                await MainActor.run {
                    self.searchResults = results
                    self.isSearching = false
                    
                    if results.isEmpty {
                        print("ℹ️ No medications found for: \(self.searchText)")
                    } else {
                        print("✅ Found \(results.count) medications for: \(self.searchText)")
                    }
                }
            } catch MedicationAPIError.networkError {
                await MainActor.run {
                    print("❌ Network error - check internet connection")
                    self.searchResults = []
                    self.isSearching = false
                    self.errorMessage = "Check your internet connection and try again"
                    self.showingError = true
                }
            } catch MedicationAPIError.rateLimited {
                await MainActor.run {
                    print("⏰ Rate limited - waiting before retry")
                    self.searchResults = []
                    self.isSearching = false
                    self.errorMessage = "Too many requests. Please wait a moment and try again."
                    self.showingError = true
                }
            } catch {
                await MainActor.run {
                    print("❌ Search error: \(error.localizedDescription)")
                    self.searchResults = []
                    self.isSearching = false
                    self.errorMessage = "Search temporarily unavailable. Please try again."
                    self.showingError = true
                }
            }
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
}

// MARK: - Supporting Views

private struct MedicationCard: View {
    let medication: Medication
    let isSelected: Bool
    let action: () -> Void
    
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
                
                // Show RxCUI for verification
                Text("RxCUI: \(medication.rxcui)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .opacity(0.7)
            }
            
            Spacer()
            
            Button(action: action) {
                Image(systemName: isSelected ? "xmark.circle.fill" : "plus.circle")
                    .font(.title3)
                    .foregroundColor(isSelected ? .red : .blue)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isSelected ? Color.green.opacity(0.1) : Color(.systemGray6))
                .stroke(isSelected ? Color.green.opacity(0.3) : Color.clear, lineWidth: 1)
        )
    }
}

private struct SearchCard: View {
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
                        Text("Also known as: \(synonym)")
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
