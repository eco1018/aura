//
//
//  DiaryEntryViewModel.swift
//  aura
//
//  Created by Ella A. Sadduq on 5/22/25.
//
//
//  Enhanced DiaryEntryViewModel.swift
//  aura
//
//  Enhanced with comprehensive data tracking and validation

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class DiaryEntryViewModel: ObservableObject {
    @Published var diaryEntry: DiaryEntry
    @Published var isLoading: Bool = false
    @Published var saveMessage: String = ""
    @Published var hasUnsavedChanges: Bool = false
    
    private let db = Firestore.firestore()
    private let userProfile: UserProfile?
    
    init(session: DiarySession) {
        // Get current user and their profile
        let userId = Auth.auth().currentUser?.uid ?? "anonymous"
        self.userProfile = AuthViewModel.shared.userProfile
        
        // Initialize diary entry with user's custom preferences
        self.diaryEntry = DiaryEntry(userId: userId, session: session, userProfile: userProfile)
        
        print("📱 DiaryEntryViewModel initialized")
        print("   - Session: \(session)")
        print("   - User ID: \(userId)")
        print("   - User has custom actions: \(diaryEntry.actions.customActions.count)")
        print("   - User has custom urges: \(diaryEntry.urges.customUrges.count)")
        print("   - User has custom goals: \(diaryEntry.goals.goals.count)")
        print("   - User has emotions: \(diaryEntry.emotions.emotions.count)")
    }
    
    // MARK: - Action Updates with Validation
    func updateActionRating(_ action: String, value: Int) {
        let clampedValue = max(0, min(10, value))
        
        switch action {
        case "selfHarm":
            diaryEntry.actions.selfHarm = IntensityRating(value: clampedValue)
            print("📝 Updated self-harm action: \(clampedValue)")
        case "suicide":
            diaryEntry.actions.suicide = IntensityRating(value: clampedValue)
            print("📝 Updated suicide action: \(clampedValue)")
        default:
            // Handle custom actions
            if diaryEntry.actions.customActions.keys.contains(action) {
                diaryEntry.actions.customActions[action] = IntensityRating(value: clampedValue)
                print("📝 Updated custom action '\(action)': \(clampedValue)")
            } else {
                print("⚠️ Attempted to update unknown action: \(action)")
            }
        }
        hasUnsavedChanges = true
    }
    
    // MARK: - Urge Updates with Validation
    func updateUrgeRating(_ urge: String, value: Int) {
        let clampedValue = max(0, min(10, value))
        
        switch urge {
        case "selfHarmUrge":
            diaryEntry.urges.selfHarmUrge = IntensityRating(value: clampedValue)
            print("📝 Updated self-harm urge: \(clampedValue)")
        case "suicideUrge":
            diaryEntry.urges.suicideUrge = IntensityRating(value: clampedValue)
            print("📝 Updated suicide urge: \(clampedValue)")
        case "quitTherapyUrge":
            diaryEntry.urges.quitTherapyUrge = IntensityRating(value: clampedValue)
            print("📝 Updated quit therapy urge: \(clampedValue)")
        default:
            // Handle custom urges
            if diaryEntry.urges.customUrges.keys.contains(urge) {
                diaryEntry.urges.customUrges[urge] = IntensityRating(value: clampedValue)
                print("📝 Updated custom urge '\(urge)': \(clampedValue)")
            } else {
                print("⚠️ Attempted to update unknown urge: \(urge)")
            }
        }
        hasUnsavedChanges = true
    }
    
    // MARK: - Emotion Updates with Validation
    func updateEmotionRating(_ emotion: String, value: Int) {
        let clampedValue = max(0, min(10, value))
        diaryEntry.emotions.emotions[emotion] = IntensityRating(value: clampedValue)
        print("📝 Updated emotion '\(emotion)': \(clampedValue)")
        hasUnsavedChanges = true
    }
    
    // MARK: - Skill Updates with Validation
    func updateSkillEffectiveness(_ effectiveness: Int) {
        let clampedValue = max(1, min(10, effectiveness))
        diaryEntry.skills.effectiveness = clampedValue
        print("📝 Updated skill effectiveness: \(clampedValue)")
        hasUnsavedChanges = true
    }
    
    func getSkillEffectiveness() -> Int {
        return diaryEntry.skills.effectiveness
    }
    
    // MARK: - Medication Updates with Enhanced Tracking
    func updateMedicationCompliance(took: Bool, missed: Int = 0, notes: String = "") {
        diaryEntry.medications.tookMedication = took
        diaryEntry.medications.missedDoses = max(0, missed)
        diaryEntry.medications.notes = notes.trimmingCharacters(in: .whitespaces)
        
        print("📝 Updated medication compliance:")
        print("   - Took medication: \(took)")
        print("   - Missed doses: \(missed)")
        print("   - Notes: '\(notes)'")
        
        hasUnsavedChanges = true
    }
    
    func updateIndividualMedication(medicationId: String, taken: Bool, notes: String = "") {
        diaryEntry.medications.updateMedicationEntry(
            medicationId: medicationId,
            taken: taken,
            notes: notes
        )
        print("📝 Updated individual medication \(medicationId): taken=\(taken)")
        hasUnsavedChanges = true
    }
    
    func getMedicationCompliance() -> Bool {
        return diaryEntry.medications.tookMedication
    }
    
    func getMedicationNotes() -> String {
        return diaryEntry.medications.notes
    }
    
    // MARK: - Goals Updates with Validation
    func updateGoalCompletion(_ goal: String, completed: Bool) {
        if diaryEntry.goals.goals.keys.contains(goal) {
            diaryEntry.goals.goals[goal] = completed
            print("📝 Updated goal '\(goal)': \(completed ? "completed" : "not completed")")
            hasUnsavedChanges = true
        } else {
            print("⚠️ Attempted to update unknown goal: \(goal)")
        }
    }
    
    // MARK: - Daily Note Updates with Enhanced Validation
    func updateDailyNote(note: String = "", mood: String = "", highlights: String = "") {
        var updated = false
        
        if !note.isEmpty {
            let trimmedNote = note.trimmingCharacters(in: .whitespaces)
            diaryEntry.dailyNote.note = trimmedNote
            print("📝 Updated daily note: '\(trimmedNote.prefix(50))...'")
            updated = true
        }
        
        if !mood.isEmpty {
            let trimmedMood = mood.trimmingCharacters(in: .whitespaces)
            diaryEntry.dailyNote.mood = trimmedMood
            print("📝 Updated daily mood: '\(trimmedMood)'")
            updated = true
        }
        
        if !highlights.isEmpty {
            let trimmedHighlights = highlights.trimmingCharacters(in: .whitespaces)
            diaryEntry.dailyNote.highlights = trimmedHighlights
            print("📝 Updated daily highlights: '\(trimmedHighlights.prefix(50))...'")
            updated = true
        }
        
        if updated {
            hasUnsavedChanges = true
        }
    }
    
    func getDailyNote() -> String {
        return diaryEntry.dailyNote.note
    }
    
    func getDailyMood() -> String {
        return diaryEntry.dailyNote.mood
    }
    
    func getDailyHighlights() -> String {
        return diaryEntry.dailyNote.highlights
    }
    
    // MARK: - Data Validation Before Save
    private func validateDiaryEntry() -> (isValid: Bool, errors: [String]) {
        var errors: [String] = []
        
        // Check if user exists
        if diaryEntry.userId.isEmpty || diaryEntry.userId == "anonymous" {
            errors.append("No authenticated user")
        }
        
        // Validate action ratings
        let allActionValues = [diaryEntry.actions.selfHarm.value, diaryEntry.actions.suicide.value] +
                            diaryEntry.actions.customActions.values.map { $0.value }
        if allActionValues.contains(where: { $0 < 0 || $0 > 10 }) {
            errors.append("Invalid action rating values")
        }
        
        // Validate urge ratings
        let allUrgeValues = [diaryEntry.urges.selfHarmUrge.value, diaryEntry.urges.suicideUrge.value, diaryEntry.urges.quitTherapyUrge.value] +
                          diaryEntry.urges.customUrges.values.map { $0.value }
        if allUrgeValues.contains(where: { $0 < 0 || $0 > 10 }) {
            errors.append("Invalid urge rating values")
        }
        
        // Validate emotion ratings
        let allEmotionValues = diaryEntry.emotions.emotions.values.map { $0.value }
        if allEmotionValues.contains(where: { $0 < 0 || $0 > 10 }) {
            errors.append("Invalid emotion rating values")
        }
        
        // Validate skill effectiveness
        if diaryEntry.skills.effectiveness < 1 || diaryEntry.skills.effectiveness > 10 {
            errors.append("Invalid skill effectiveness rating")
        }
        
        return (isValid: errors.isEmpty, errors: errors)
    }
    
    // MARK: - Comprehensive Save with Validation
    func saveEntry(completion: @escaping (Bool) -> Void) {
        print("💾 Starting diary entry save process...")
        
        // Validate entry before saving
        let validation = validateDiaryEntry()
        if !validation.isValid {
            print("❌ Validation failed:")
            validation.errors.forEach { print("   - \($0)") }
            saveMessage = "Validation failed: \(validation.errors.joined(separator: ", "))"
            completion(false)
            return
        }
        
        // Print comprehensive data summary before save
        printDiaryEntrySummary()
        
        isLoading = true
        
        do {
            try db.collection("users")
                .document(diaryEntry.userId)
                .collection("diaryEntries")
                .addDocument(from: diaryEntry) { [weak self] error in
                    DispatchQueue.main.async {
                        self?.isLoading = false
                        
                        if let error = error {
                            print("❌ Failed to save diary entry: \(error.localizedDescription)")
                            self?.saveMessage = "Failed to save entry: \(error.localizedDescription)"
                            completion(false)
                        } else {
                            print("✅ Diary entry saved successfully!")
                            self?.saveMessage = "Entry saved successfully!"
                            self?.hasUnsavedChanges = false
                            completion(true)
                        }
                    }
                }
        } catch {
            DispatchQueue.main.async {
                self.isLoading = false
                print("❌ Encoding error: \(error.localizedDescription)")
                self.saveMessage = "Failed to encode entry: \(error.localizedDescription)"
                completion(false)
            }
        }
    }
    
    // MARK: - Comprehensive Data Summary
    private func printDiaryEntrySummary() {
        print("📊 DIARY ENTRY SUMMARY - Ready to Save:")
        print("   User ID: \(diaryEntry.userId)")
        print("   Session: \(diaryEntry.session)")
        print("   Timestamp: \(diaryEntry.timestamp)")
        
        print("   ACTIONS:")
        print("     - Self-harm: \(diaryEntry.actions.selfHarm.value)")
        print("     - Suicide: \(diaryEntry.actions.suicide.value)")
        for (key, value) in diaryEntry.actions.customActions {
            print("     - \(key): \(value.value)")
        }
        
        print("   URGES:")
        print("     - Self-harm urge: \(diaryEntry.urges.selfHarmUrge.value)")
        print("     - Suicide urge: \(diaryEntry.urges.suicideUrge.value)")
        print("     - Quit therapy urge: \(diaryEntry.urges.quitTherapyUrge.value)")
        for (key, value) in diaryEntry.urges.customUrges {
            print("     - \(key): \(value.value)")
        }
        
        print("   EMOTIONS:")
        for (key, value) in diaryEntry.emotions.emotions {
            print("     - \(key): \(value.value)")
        }
        
        print("   SKILLS:")
        print("     - Effectiveness: \(diaryEntry.skills.effectiveness)")
        
        print("   MEDICATIONS:")
        print("     - Took medication: \(diaryEntry.medications.tookMedication)")
        print("     - Missed doses: \(diaryEntry.medications.missedDoses)")
        print("     - Notes: '\(diaryEntry.medications.notes)'")
        print("     - Individual medications: \(diaryEntry.medications.individualMedications.count)")
        
        print("   GOALS:")
        for (key, value) in diaryEntry.goals.goals {
            print("     - \(key): \(value ? "completed" : "not completed")")
        }
        
        print("   DAILY NOTE:")
        print("     - Note: '\(diaryEntry.dailyNote.note.prefix(100))...'")
        print("     - Mood: '\(diaryEntry.dailyNote.mood)'")
        print("     - Highlights: '\(diaryEntry.dailyNote.highlights.prefix(100))...'")
    }
    
    // MARK: - Helper Methods
    
    /// Get all actions (fixed + custom) for display
    func getAllActions() -> [(key: String, title: String, value: IntensityRating)] {
        var actions: [(key: String, title: String, value: IntensityRating)] = []
        
        // Add fixed actions (always first)
        actions.append(("selfHarm", "Self-harm", diaryEntry.actions.selfHarm))
        actions.append(("suicide", "Suicide", diaryEntry.actions.suicide))
        
        // Add custom actions
        for (key, value) in diaryEntry.actions.customActions {
            actions.append((key, key, value))
        }
        
        return actions
    }
    
    /// Get all urges (fixed + custom) for display
    func getAllUrges() -> [(key: String, title: String, value: IntensityRating)] {
        var urges: [(key: String, title: String, value: IntensityRating)] = []
        
        // Add fixed urges (always first)
        urges.append(("selfHarmUrge", "Self-harm urge", diaryEntry.urges.selfHarmUrge))
        urges.append(("suicideUrge", "Suicide urge", diaryEntry.urges.suicideUrge))
        urges.append(("quitTherapyUrge", "Quit therapy urge", diaryEntry.urges.quitTherapyUrge))
        
        // Add custom urges
        for (key, value) in diaryEntry.urges.customUrges {
            urges.append((key, key, value))
        }
        
        return urges
    }
    
    /// Get all emotions for display
    func getAllEmotions() -> [(key: String, title: String, value: IntensityRating)] {
        return diaryEntry.emotions.emotions.map { (key: $0.key, title: $0.key, value: $0.value) }
    }
    
    /// Get all goals for display
    func getAllGoals() -> [(key: String, title: String, completed: Bool)] {
        return diaryEntry.goals.goals.map { (key: $0.key, title: $0.key, completed: $0.value) }
    }
    
    /// Get all individual medications for display
    func getAllMedications() -> [DailyMedicationEntry] {
        return diaryEntry.medications.individualMedications
    }
    
    // MARK: - Auto-save functionality (optional)
    func autoSave() {
        guard hasUnsavedChanges else { return }
        
        print("💾 Auto-saving diary entry...")
        saveEntry { success in
            if success {
                print("✅ Auto-save successful")
            } else {
                print("❌ Auto-save failed")
            }
        }
    }
}
