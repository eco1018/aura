//
//
//
//  MedicationSettingsView.swift
//  aura
//
//  Complete medication management in Settings

import SwiftUI

struct MedicationSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authVM: AuthViewModel
    @State private var medications: [Medication] = []
    @State private var showingAddMedication = false
    @State private var isLoading = false
    @State private var showingSaveConfirmation = false
    @State private var editingMedication: Medication?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if isLoading {
                    ProgressView("Loading medications...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    medicationsList
                }
            }
            .navigationTitle("Medications")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        showingAddMedication = true
                    }
                    .fontWeight(.semibold)
                }
            }
        }
        .onAppear {
            loadMedications()
        }
        .sheet(isPresented: $showingAddMedication) {
            MedicationSearchSheet { newMedications in
                addMedications(newMedications)
            }
        }
        .sheet(item: $editingMedication) { medication in
            MedicationEditSheet(medication: medication) { updatedMedication in
                updateMedication(updatedMedication)
            }
        }
        .alert("Medications Updated", isPresented: $showingSaveConfirmation) {
            Button("OK") { }
        } message: {
            Text("Your medication list has been successfully updated.")
        }
    }
    
    private var medicationsList: some View {
        Group {
            if medications.isEmpty {
                emptyStateView
            } else {
                List {
                    ForEach(medications) { medication in
                        MedicationRow(medication: medication) {
                            editingMedication = medication
                        } onToggleActive: { isActive in
                            toggleMedicationActive(medication, isActive: isActive)
                        } onDelete: {
                            deleteMedication(medication)
                        }
                    }
                    .onDelete(perform: deleteMedications)
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "pills")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No Medications Added")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Add medications to track them in your daily diary card.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Add First Medication") {
                showingAddMedication = true
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Helper Methods
    
    private func loadMedications() {
        guard let profile = authVM.userProfile else { return }
        medications = profile.medications
    }
    
    private func addMedications(_ newMedications: [Medication]) {
        medications.append(contentsOf: newMedications)
        saveMedications()
    }
    
    private func updateMedication(_ updatedMedication: Medication) {
        if let index = medications.firstIndex(where: { $0.id == updatedMedication.id }) {
            medications[index] = updatedMedication
            saveMedications()
        }
    }
    
    private func toggleMedicationActive(_ medication: Medication, isActive: Bool) {
        if let index = medications.firstIndex(where: { $0.id == medication.id }) {
            medications[index].isActive = isActive
            saveMedications()
        }
    }
    
    private func deleteMedication(_ medication: Medication) {
        medications.removeAll { $0.id == medication.id }
        saveMedications()
    }
    
    private func deleteMedications(at offsets: IndexSet) {
        medications.remove(atOffsets: offsets)
        saveMedications()
    }
    
    private func saveMedications() {
        guard let currentProfile = authVM.userProfile else { return }
        
        isLoading = true
        
        let updatedProfile = UserProfile(
            uid: currentProfile.uid,
            name: currentProfile.name,
            email: currentProfile.email,
            age: currentProfile.age,
            gender: currentProfile.gender,
            customActions: currentProfile.customActions,
            customUrges: currentProfile.customUrges,
            customGoals: currentProfile.customGoals,
            selectedEmotions: currentProfile.selectedEmotions,
            takesMedications: !medications.isEmpty,
            medications: medications,
            medicationProfileVersion: currentProfile.medicationProfileVersion + 1,
            morningReminderTime: currentProfile.morningReminderTime,
            eveningReminderTime: currentProfile.eveningReminderTime,
            hasCompletedOnboarding: true
        )
        
        updatedProfile.save { [self] success in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if success {
                    authVM.userProfile = updatedProfile
                    showingSaveConfirmation = true
                    print("✅ Medications updated successfully")
                } else {
                    print("❌ Failed to save medications")
                }
            }
        }
    }
}

// MARK: - Medication Row Component

struct MedicationRow: View {
    let medication: Medication
    let onEdit: () -> Void
    let onToggleActive: (Bool) -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(medication.displayName)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(medication.isActive ? .primary : .secondary)
                
                Text(medication.frequency.displayName)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                if let genericName = medication.genericName, genericName != medication.name {
                    Text("Generic: \(genericName)")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            VStack(spacing: 8) {
                Toggle("Active", isOn: Binding(
                    get: { medication.isActive },
                    set: { onToggleActive($0) }
                ))
                .labelsHidden()
                
                Button("Edit") {
                    onEdit()
                }
                .font(.caption)
                .foregroundColor(.blue)
            }
        }
        .padding(.vertical, 4)
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button("Delete", role: .destructive) {
                onDelete()
            }
            
            Button("Edit") {
                onEdit()
            }
            .tint(.blue)
        }
    }
}

// MARK: - Medication Search Sheet

struct MedicationSearchSheet: View {
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
                    
                    TextField("Search medications", text: $searchText)
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
                                    SearchResultCard(
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
                                
                                Text("Search for medications")
                                    .font(.headline)
                                
                                Text("Type at least 2 characters to search")
                                    .font(.body)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 40)
                        }
                    }
                }
            }
            .navigationTitle("Add Medications")
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

// MARK: - Medication Edit Sheet

struct MedicationEditSheet: View {
    @Environment(\.dismiss) private var dismiss
    let medication: Medication
    let onSave: (Medication) -> Void
    
    @State private var frequency: MedicationFrequency
    @State private var reminderTimes: [Date] = []
    @State private var isActive: Bool
    
    init(medication: Medication, onSave: @escaping (Medication) -> Void) {
        self.medication = medication
        self.onSave = onSave
        self._frequency = State(initialValue: medication.frequency)
        self._isActive = State(initialValue: medication.isActive)
        self._reminderTimes = State(initialValue: medication.reminderTimes)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Text("Medication")
                        Spacer()
                        Text(medication.displayName)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("RxCUI")
                        Spacer()
                        Text(medication.rxcui)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                } header: {
                    Text("Medication Details")
                }
                
                Section {
                    Picker("Frequency", selection: $frequency) {
                        ForEach(MedicationFrequency.allCases, id: \.self) { freq in
                            Text(freq.displayName).tag(freq)
                        }
                    }
                    
                    Toggle("Active", isOn: $isActive)
                } header: {
                    Text("Settings")
                }
                
                if frequency != .asNeeded {
                    Section {
                        ForEach(0..<recommendedTimesCount, id: \.self) { index in
                            DatePicker(
                                timeLabels[index],
                                selection: Binding(
                                    get: {
                                        reminderTimes.indices.contains(index) ? reminderTimes[index] : Date()
                                    },
                                    set: { newValue in
                                        if reminderTimes.indices.contains(index) {
                                            reminderTimes[index] = newValue
                                        } else {
                                            reminderTimes.append(newValue)
                                        }
                                    }
                                ),
                                displayedComponents: .hourAndMinute
                            )
                        }
                    } header: {
                        Text("Reminder Times")
                    }
                }
            }
            .navigationTitle("Edit Medication")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveMedication()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
        .onAppear {
            setupReminderTimes()
        }
    }
    
    private var recommendedTimesCount: Int {
        switch frequency {
        case .onceDaily: return 1
        case .twiceDaily: return 2
        case .threeTimesDaily: return 3
        case .asNeeded: return 0
        }
    }
    
    private var timeLabels: [String] {
        frequency.recommendedTimes
    }
    
    private func setupReminderTimes() {
        let neededCount = recommendedTimesCount
        
        if reminderTimes.count < neededCount {
            // Add default times
            let defaultTimes = [
                Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: Date()) ?? Date(),
                Calendar.current.date(bySettingHour: 20, minute: 0, second: 0, of: Date()) ?? Date(),
                Calendar.current.date(bySettingHour: 14, minute: 0, second: 0, of: Date()) ?? Date()
            ]
            
            while reminderTimes.count < neededCount {
                reminderTimes.append(defaultTimes[reminderTimes.count])
            }
        } else if reminderTimes.count > neededCount {
            reminderTimes = Array(reminderTimes.prefix(neededCount))
        }
    }
    
    private func saveMedication() {
        var updatedMedication = medication
        updatedMedication.frequency = frequency
        updatedMedication.isActive = isActive
        updatedMedication.reminderTimes = Array(reminderTimes.prefix(recommendedTimesCount))
        
        onSave(updatedMedication)
        dismiss()
    }
}

// MARK: - Shared Card Components

private struct SearchResultCard: View {
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
    MedicationSettingsView()
        .environmentObject(AuthViewModel.shared)
}
