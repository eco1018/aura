//
//  IntensityRating.swift
//  aura
//
//  Created by Ella A. Sadduq on 5/22/25.
//


//
//  IntensityRating.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/28/25.
//

import Foundation

struct IntensityRating: Codable {
    var value: Int  // 0-10 scale
    var timestamp: Date
    var confidence: Double?  // User's confidence in their rating (0.0-1.0)
    
    init(value: Int, confidence: Double? = nil) {
        self.value = max(0, min(10, value))  // Clamp to 0-10
        self.timestamp = Date()
        self.confidence = confidence
    }
}