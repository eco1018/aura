//
//
//  DiaryEntryViewModel.swift
//  aura
//
//  Created by Ella A. Sadduq on 5/22/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class DiaryEntryViewModel: ObservableObject {
    @Published var diaryEntry: DiaryEntry
    @Published var isLoading: Bool = false
    @Published var saveMessage: String = ""
    
    private let db = Firestore.firestore()
    private let userProfile: UserProfile?
    
    init(session: DiarySession) {
        // Get current user and their profile
        let userId = Auth.auth().currentUser?.uid ?? "anonymous"
        self.userProfile = AuthViewModel.shared.userProfile
        
        // Initialize diary entry with user's custom preferences
        self.diaryEntry = DiaryEntry(userId: userId, session: session, userProfile: userProfile)
    }
    
    // MARK: - Action Updates
    func updateActionRating(_ action: String, value: Int) {
        switch action {
        case "selfHarm":
            diaryEntry.actions.selfHarm = IntensityRating(value: value)
        case "suicide":
            diaryEntry.actions.suicide = IntensityRating(value: value)
        default:
            // Handle custom actions
            if diaryEntry.actions.customActions.keys.contains(action) {
                diaryEntry.actions.customActions[action] = IntensityRating(value: value)
            }
        }
    }
    
    // MARK: - Urge Updates
    func updateUrgeRating(_ urge: String, value: Int) {
        switch urge {
        case "selfHarmUrge":
            diaryEntry.urges.selfHarmUrge = IntensityRating(value: value)
        case "suicideUrge":
            diaryEntry.urges.suicideUrge = IntensityRating(value: value)
        case "quitTherapyUrge":
            diaryEntry.urges.quitTherapyUrge = IntensityRating(value: value)
        default:
            // Handle custom urges
            if diaryEntry.urges.customUrges.keys.contains(urge) {
                diaryEntry.urges.customUrges[urge] = IntensityRating(value: value)
            }
        }
    }
    
    // MARK: - Emotion Updates
    func updateEmotionRating(_ emotion: String, value: Int) {
        diaryEntry.emotions.emotions[emotion] = IntensityRating(value: value)
    }
    
    // MARK: - Skill Updates
    func updateSkillEffectiveness(_ effectiveness: Int) {
        diaryEntry.skills.effectiveness = max(1, min(10, effectiveness))
    }
    
    func getSkillEffectiveness() -> Int {
        return diaryEntry.skills.effectiveness
    }
    
    // MARK: - Medication Updates
    func updateMedicationCompliance(took: Bool, missed: Int = 0, notes: String = "") {
        diaryEntry.medications.tookMedication = took
        diaryEntry.medications.missedDoses = missed
        diaryEntry.medications.notes = notes
    }
    
    func getMedicationCompliance() -> Bool {
        return diaryEntry.medications.tookMedication
    }
    
    func getMedicationNotes() -> String {
        return diaryEntry.medications.notes
    }
    
    // MARK: - Goals Updates
    func updateGoalCompletion(_ goal: String, completed: Bool) {
        diaryEntry.goals.goals[goal] = completed
    }
    
    // MARK: - Daily Note Updates
    func updateDailyNote(note: String = "", mood: String = "", highlights: String = "") {
        if !note.isEmpty { diaryEntry.dailyNote.note = note }
        if !mood.isEmpty { diaryEntry.dailyNote.mood = mood }
        if !highlights.isEmpty { diaryEntry.dailyNote.highlights = highlights }
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
    
    // MARK: - Save Entry
    func saveEntry(completion: @escaping (Bool) -> Void) {
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
                            self?.saveMessage = "Failed to save entry"
                            completion(false)
                        } else {
                            print("✅ Diary entry saved successfully")
                            self?.saveMessage = "Entry saved successfully!"
                            completion(true)
                        }
                    }
                }
        } catch {
            DispatchQueue.main.async {
                self.isLoading = false
                self.saveMessage = "Failed to save entry"
                completion(false)
            }
        }
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
}
