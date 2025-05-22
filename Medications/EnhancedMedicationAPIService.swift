//
//  EnhancedMedicationAPIService.swift
//  aura
//
//  Created by Ella A. Sadduq on 5/23/25.
//
//
//  EnhancedMedicationAPIService.swift
//  aura
//
//  Production-ready RxNorm API with detailed medication selection

import Foundation

// MARK: - Enhanced Models for Multi-Step Selection

struct MedicationName: Codable, Identifiable, Hashable {
    let id = UUID()
    let name: String
    let rxcui: String
    let isGeneric: Bool
    
    var displayName: String {
        return isGeneric ? "\(name) (Generic)" : name
    }
}

struct MedicationFormulation: Codable, Identifiable, Hashable {
    let id = UUID()
    let name: String
    let rxcui: String
    let tty: String // Term Type (SBD, SCD, etc.)
    let strength: String?
    let dosageForm: String?
    
    var displayName: String {
        var components: [String] = []
        
        if let strength = strength {
            components.append(strength)
        }
        
        if let form = dosageForm {
            components.append(form)
        }
        
        if components.isEmpty {
            return name
        }
        
        return components.joined(separator: " ")
    }
    
    var fullDisplayName: String {
        return "\(name) - \(displayName)"
    }
}

struct MedicationStrengthOption: Codable, Identifiable, Hashable {
    let id = UUID()
    let strength: String
    let rxcui: String
    let dosageForm: String
    let brandName: String?
    
    var displayName: String {
        r
