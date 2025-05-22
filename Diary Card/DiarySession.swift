//
//  DiarySession.swift
//  aura
//
//  Created by Ella A. Sadduq on 5/22/25.
//


//
//  DiarySession.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/28/25.
//

import Foundation

enum DiarySession: String, Codable, CaseIterable {
    case morning = "morning"
    case evening = "evening"
    case manual = "manual"  // User-initiated outside scheduled times
    
    var displayName: String {
        switch self {
        case .morning:
            return "Morning Check-in"
        case .evening:
            return "Evening Check-in"
        case .manual:
            return "Daily Check-in"
        }
    }
    
    var timeDescription: String {
        switch self {
        case .morning:
            return "Start your day with reflection"
        case .evening:
            return "End your day with mindfulness"
        case .manual:
            return "Take a moment for yourself"
        }
    }
}