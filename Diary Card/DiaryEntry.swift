//
//  DiaryEntry.swift
//  aura
//
//  Created by Ella A. Sadduq on 5/22/25.
//


//
//  DiaryEntry.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/28/25.
//

import Foundation
import FirebaseFirestore

// MARK: - Basic DiaryEntry for our first implementation
struct DiaryEntry: Codable, Identifiable {
    @DocumentID var id: String?
    
    // Core metadata
    let userId: String
    let timestamp: Date
    let session: DiarySession
    
    // Actions section (starting simple)
    var actions: ActionData
    
    // Placeholder for other sections (we'll add these incrementally)
    // var urges: UrgeData
    // var emotions: EmotionData
    // var skills: SkillData
    // var medications: MedicationData
    // var goals: GoalData
    // var dailyNote: DailyNoteData
    
    init(userId: String, session: DiarySession) {
        self.userId = userId
        self.session = session
        self.timestamp = Date()
        self.actions = ActionData()
    }
}

// MARK: - ActionData (Simple version to start)
struct ActionData: Codable {
    var selfHarmUrges: IntensityRating
    var suicidalThoughts: IntensityRating
    
    // TODO: Add custom actions later
    // var customActions: [String: IntensityRating] = [:]
    
    init() {
        self.selfHarmUrges = IntensityRating(value: 0)
        self.suicidalThoughts = IntensityRating(value: 0)
    }
}