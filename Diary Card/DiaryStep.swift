//
//  DiaryStep.swift
//  aura
//
//  Created by Ella A. Sadduq on 5/22/25.
//


//
//  DiaryStep.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/28/25.
//

import Foundation

enum DiaryStep: String, CaseIterable {
    case actions = "actions"
    case urges = "urges"
    case emotions = "emotions"
    case skills = "skills"
    case medications = "medications"
    case goals = "goals"
    case dailyNote = "dailyNote"
    
    var title: String {
        switch self {
        case .actions:
            return "Actions"
        case .urges:
            return "Urges"
        case .emotions:
            return "Emotions"
        case .skills:
            return "Skills Used"
        case .medications:
            return "Medications"
        case .goals:
            return "Goals"
        case .dailyNote:
            return "Daily Note"
        }
    }
    
    var description: String {
        switch self {
        case .actions:
            return "Rate any problematic actions you experienced today"
        case .urges:
            return "Rate the intensity of urges you felt today"
        case .emotions:
            return "Rate your emotions on a 0-10 scale"
        case .skills:
            return "Which DBT skills did you use today?"
        case .medications:
            return "Did you take your medications as prescribed?"
        case .goals:
            return "How did you progress toward your goals today?"
        case .dailyNote:
            return "Any additional thoughts or reflections?"
        }
    }
    
    var systemImage: String {
        switch self {
        case .actions:
            return "exclamationmark.triangle"
        case .urges:
            return "flame"
        case .emotions:
            return "heart"
        case .skills:
            return "brain.head.profile"
        case .medications:
            return "pills"
        case .goals:
            return "target"
        case .dailyNote:
            return "note.text"
        }
    }
    
    func next() -> DiaryStep? {
        guard let currentIndex = DiaryStep.allCases.firstIndex(of: self) else { return nil }
        let nextIndex = currentIndex + 1
        return nextIndex < DiaryStep.allCases.count ? DiaryStep.allCases[nextIndex] : nil
    }
    
    func previous() -> DiaryStep? {
        guard let currentIndex = DiaryStep.allCases.firstIndex(of: self) else { return nil }
        let previousIndex = currentIndex - 1
        return previousIndex >= 0 ? DiaryStep.allCases[previousIndex] : nil
    }
    
    var progressPercentage: Double {
        guard let currentIndex = DiaryStep.allCases.firstIndex(of: self) else { return 0 }
        return Double(currentIndex + 1) / Double(DiaryStep.allCases.count)
    }
}
