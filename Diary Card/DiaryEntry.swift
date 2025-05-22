//
//
//  DiaryEntry.swift
//  aura
//
//  Created by Ella A. Sadduq on 5/22/25.
//

import Foundation
import FirebaseFirestore

// MARK: - DiaryEntry for personalized tracking
struct DiaryEntry: Codable, Identifiable {
    @DocumentID var id: String?
    
    // Core metadata
    let userId: String
    let timestamp: Date
    let session: DiarySession
    
    // Tracking sections
    var actions: ActionData
    var urges: UrgeData
    var emotions: EmotionData
    var skills: SkillData
    var medications: MedicationData
    var goals: GoalData
    var dailyNote: DailyNoteData
    
    init(userId: String, session: DiarySession, userProfile: UserProfile?) {
        self.userId = userId
        self.session = session
        self.timestamp = Date()
        
        // Initialize with user's custom preferences
        self.actions = ActionData(customActions: userProfile?.customActions ?? [])
        self.urges = UrgeData(customUrges: userProfile?.customUrges ?? [])
        self.emotions = EmotionData(selectedEmotions: userProfile?.selectedEmotions ?? [])
        self.skills = SkillData()
        self.medications = MedicationData()
        self.goals = GoalData(customGoals: userProfile?.customGoals ?? [])
        self.dailyNote = DailyNoteData()
    }
}

// MARK: - ActionData with fixed + custom actions
struct ActionData: Codable {
    // Fixed actions (always tracked for every user)
    var selfHarm: IntensityRating
    var suicide: IntensityRating
    
    // User's custom actions
    var customActions: [String: IntensityRating]
    
    init(customActions: [String] = []) {
        // Fixed actions that every user tracks
        self.selfHarm = IntensityRating(value: 0)
        self.suicide = IntensityRating(value: 0)
        
        // Initialize custom actions with 0 ratings
        self.customActions = [:]
        for action in customActions {
            self.customActions[action] = IntensityRating(value: 0)
        }
    }
}

// MARK: - UrgeData with fixed + custom urges
struct UrgeData: Codable {
    // Fixed urges (tracked for every user)
    var selfHarmUrge: IntensityRating
    var suicideUrge: IntensityRating
    var quitTherapyUrge: IntensityRating
    
    // User's custom urges
    var customUrges: [String: IntensityRating]
    
    init(customUrges: [String] = []) {
        // Fixed urges that every user tracks
        self.selfHarmUrge = IntensityRating(value: 0)
        self.suicideUrge = IntensityRating(value: 0)
        self.quitTherapyUrge = IntensityRating(value: 0)
        
        // Initialize custom urges with 0 ratings
        self.customUrges = [:]
        for urge in customUrges {
            self.customUrges[urge] = IntensityRating(value: 0)
        }
    }
}

// MARK: - EmotionData with selected emotions
struct EmotionData: Codable {
    var emotions: [String: IntensityRating]
    
    init(selectedEmotions: [String] = []) {
        self.emotions = [:]
        
        // Initialize selected emotions with 5 (neutral) rating
        for emotion in selectedEmotions {
            self.emotions[emotion] = IntensityRating(value: 5)
        }
        
        // If no emotions selected, use common defaults
        if selectedEmotions.isEmpty {
            let defaultEmotions = ["Happy", "Sad", "Angry", "Anxious", "Calm", "Frustrated"]
            for emotion in defaultEmotions {
                self.emotions[emotion] = IntensityRating(value: 5)
            }
        }
    }
}

// MARK: - SkillData for effectiveness rating
struct SkillData: Codable {
    var effectiveness: Int // 1-10 scale of how effective skills were
    
    init() {
        self.effectiveness = 5 // Default to middle of scale
    }
}

// MARK: - MedicationData for medication tracking
struct MedicationData: Codable {
    var tookMedication: Bool
    var missedDoses: Int
    var notes: String
    
    init() {
        self.tookMedication = false
        self.missedDoses = 0
        self.notes = ""
    }
}

// MARK: - GoalData with custom goals
struct GoalData: Codable {
    var goals: [String: Bool]
    
    init(customGoals: [String] = []) {
        self.goals = [:]
        
        // Initialize custom goals
        for goal in customGoals {
            self.goals[goal] = false
        }
        
        // If no custom goals, use defaults
        if customGoals.isEmpty {
            let defaultGoals = ["Use DBT Skill", "Reach Out", "Self-Care"]
            for goal in defaultGoals {
                self.goals[goal] = false
            }
        }
    }
}

// MARK: - DailyNoteData for reflection
struct DailyNoteData: Codable {
    var note: String
    var mood: String
    var highlights: String
    
    init() {
        self.note = ""
        self.mood = ""
        self.highlights = ""
    }
}
