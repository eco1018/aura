//
//
//
//  Medication.swift
//  aura
//
//  Created by Assistant on 5/22/25.
//

import Foundation
import FirebaseFirestore

// MARK: - Medication Model
struct Medication: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    
    let rxcui: String // RxNorm Concept Unique Identifier
    let name: String // Display name (e.g., "Sertraline 50mg")
    let genericName: String? // Generic name if different
    let strength: String? // Dosage strength (e.g., "50mg")
    let dosageForm: String? // Form (e.g., "tablet", "capsule")
    
    // User-specific settings
    var frequency: MedicationFrequency
    var reminderTimes: [Date]
    var isActive: Bool
    var dateAdded: Date
    
    init(rxcui: String, name: String, genericName: String? = nil, strength: String? = nil, dosageForm: String? = nil) {
        self.rxcui = rxcui
        self.name = name
        self.genericName = genericName
        self.strength = strength
        self.dosageForm = dosageForm
        self.frequency = .onceDaily
        self.reminderTimes = []
        self.isActive = true
        self.dateAdded = Date()
    }
    
    // Display name for UI
    var displayName: String {
        if let strength = strength {
            return "\(name) \(strength)"
        }
        return name
    }
    
    // Simple name without dosage for grouping
    var simpleName: String {
        return genericName ?? name.components(separatedBy: " ").first ?? name
    }
}

// MARK: - Medication Frequency
enum MedicationFrequency: String, Codable, CaseIterable {
    case onceDaily = "once_daily"
    case twiceDaily = "twice_daily"
    case threeTimesDaily = "three_times_daily"
    case asNeeded = "as_needed"
    
    var displayName: String {
        switch self {
        case .onceDaily:
            return "Once daily"
        case .twiceDaily:
            return "Twice daily"
        case .threeTimesDaily:
            return "Three times daily"
        case .asNeeded:
            return "As needed"
        }
    }
    
    var recommendedTimes: [String] {
        switch self {
        case .onceDaily:
            return ["Morning"]
        case .twiceDaily:
            return ["Morning", "Evening"]
        case .threeTimesDaily:
            return ["Morning", "Afternoon", "Evening"]
        case .asNeeded:
            return []
        }
    }
}

// MARK: - Medication Search Result (from API)
struct MedicationSearchResult: Codable, Identifiable {
    let id = UUID()
    let rxcui: String
    let name: String
    let synonym: String?
    let tty: String? // Term Type (e.g., "SBD" for Semantic Branded Drug)
    
    var displayName: String {
        return name
    }
    
    // Convert search result to Medication
    func toMedication() -> Medication {
        // Parse strength and form from name if possible
        let components = name.components(separatedBy: " ")
        var strength: String?
        var dosageForm: String?
        
        // Simple parsing - look for common patterns
        for component in components {
            if component.lowercased().contains("mg") || component.lowercased().contains("ml") {
                strength = component
            } else if ["tablet", "capsule", "liquid", "injection"].contains(component.lowercased()) {
                dosageForm = component.lowercased()
            }
        }
        
        return Medication(
            rxcui: rxcui,
            name: name,
            genericName: synonym,
            strength: strength,
            dosageForm: dosageForm
        )
    }
}

// MARK: - Daily Medication Entry (for DiaryCard)
struct DailyMedicationEntry: Codable {
    let medicationId: String
    let medicationName: String // Snapshot for historical integrity
    var taken: Bool
    var takenAt: Date?
    var skippedReason: String?
    var notes: String?
    
    init(medicationId: String, medicationName: String) {
        self.medicationId = medicationId
        self.medicationName = medicationName
        self.taken = false
        self.takenAt = nil
        self.skippedReason = nil
        self.notes = nil
    }
}

// MARK: - Medication Profile Version (for historical tracking)
struct MedicationProfileSnapshot: Codable {
    let userId: String
    let medications: [Medication]
    let version: Int
    let createdAt: Date
    
    init(userId: String, medications: [Medication], version: Int) {
        self.userId = userId
        self.medications = medications
        self.version = version
        self.createdAt = Date()
    }
}
