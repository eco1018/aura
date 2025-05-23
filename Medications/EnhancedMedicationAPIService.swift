//
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
        return "\(strength) \(dosageForm)"
    }
    
    var fullDisplayName: String {
        if let brand = brandName {
            return "\(brand) \(strength) \(dosageForm)"
        }
        return "\(strength) \(dosageForm)"
    }
}

// MARK: - Enhanced API Service Protocol
protocol EnhancedMedicationAPIService {
    func searchMedicationNames(query: String) async throws -> [MedicationName]
    func getFormulations(for medication: MedicationName) async throws -> [MedicationFormulation]
    func getStrengths(for formulation: MedicationFormulation) async throws -> [MedicationStrengthOption]
}

// MARK: - Production Enhanced RxNorm API Service
class ProductionRxNormAPIService: EnhancedMedicationAPIService {
    private let baseURL = "https://rxnav.nlm.nih.gov/REST"
    private let session: URLSession
    
    init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15.0
        config.timeoutIntervalForResource = 30.0
        self.session = URLSession(configuration: config)
    }
    
    // MARK: - Step 1: Search Medication Names
    func searchMedicationNames(query: String) async throws -> [MedicationName] {
        let trimmedQuery = query.trimmingCharacters(in: .whitespaces)
        
        guard !trimmedQuery.isEmpty && trimmedQuery.count >= 2 else {
            throw MedicationAPIError.invalidQuery
        }
        
        guard let encodedQuery = trimmedQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw MedicationAPIError.invalidQuery
        }
        
        let urlString = "\(baseURL)/drugs.json?name=\(encodedQuery)"
        guard let url = URL(string: urlString) else {
            throw MedicationAPIError.invalidURL
        }
        
        print("🔍 Enhanced name search: \(urlString)")
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw MedicationAPIError.networkError
            }
            
            if httpResponse.statusCode == 429 {
                throw MedicationAPIError.rateLimited
            }
            
            guard httpResponse.statusCode == 200 else {
                throw MedicationAPIError.networkError
            }
            
            let decoder = JSONDecoder()
            let apiResponse = try decoder.decode(EnhancedDrugsResponse.self, from: data)
            
            let results = parseMedicationNames(apiResponse)
            print("✅ Enhanced name search found \(results.count) results")
            return results
            
        } catch {
            if error is MedicationAPIError {
                throw error
            } else {
                print("❌ Network error: \(error)")
                throw MedicationAPIError.networkError
            }
        }
    }
    
    // MARK: - Step 2: Get Formulations
    func getFormulations(for medication: MedicationName) async throws -> [MedicationFormulation] {
        let urlString = "\(baseURL)/rxcui/\(medication.rxcui)/related.json?tty=SBD+SCD+GPCK+BPCK"
        guard let url = URL(string: urlString) else {
            throw MedicationAPIError.invalidURL
        }
        
        print("🔍 Getting formulations for: \(medication.name)")
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw MedicationAPIError.networkError
            }
            
            let decoder = JSONDecoder()
            let relatedResponse = try decoder.decode(RelatedResponse.self, from: data)
            
            let results = parseFormulations(relatedResponse, baseName: medication.name)
            print("✅ Found \(results.count) formulations")
            return results
            
        } catch {
            if error is MedicationAPIError {
                throw error
            } else {
                throw MedicationAPIError.parsingError
            }
        }
    }
    
    // MARK: - Step 3: Get Strengths
    func getStrengths(for formulation: MedicationFormulation) async throws -> [MedicationStrengthOption] {
        let urlString = "\(baseURL)/rxcui/\(formulation.rxcui)/related.json?tty=SBD+SCD"
        guard let url = URL(string: urlString) else {
            throw MedicationAPIError.invalidURL
        }
        
        print("🔍 Getting strengths for: \(formulation.name)")
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw MedicationAPIError.networkError
            }
            
            let decoder = JSONDecoder()
            let relatedResponse = try decoder.decode(RelatedResponse.self, from: data)
            
            let results = parseStrengths(relatedResponse)
            print("✅ Found \(results.count) strength options")
            return results
            
        } catch {
            if error is MedicationAPIError {
                throw error
            } else {
                throw MedicationAPIError.parsingError
            }
        }
    }
    
    // MARK: - Parsing Methods
    
    private func parseMedicationNames(_ response: EnhancedDrugsResponse) -> [MedicationName] {
        guard let drugGroup = response.drugGroup,
              let conceptGroup = drugGroup.conceptGroup else {
            return []
        }
        
        var results: [MedicationName] = []
        
        for group in conceptGroup {
            if let conceptProperties = group.conceptProperties {
                for property in conceptProperties {
                    let isGeneric = property.tty == "IN" || property.tty == "SCD"
                    
                    results.append(MedicationName(
                        name: property.name,
                        rxcui: property.rxcui,
                        isGeneric: isGeneric
                    ))
                }
            }
        }
        
        // Remove duplicates and sort
        let uniqueResults = Dictionary(grouping: results) { $0.name.lowercased() }
            .compactMapValues { $0.first }
            .values
            .sorted { $0.name < $1.name }
        
        return Array(uniqueResults.prefix(15))
    }
    
    private func parseFormulations(_ response: RelatedResponse, baseName: String) -> [MedicationFormulation] {
        guard let relatedGroup = response.relatedGroup else { return [] }
        
        var formulations: [MedicationFormulation] = []
        
        if let conceptGroup = relatedGroup.conceptGroup {
            for group in conceptGroup {
                if let conceptProperties = group.conceptProperties {
                    for property in conceptProperties {
                        // Extract strength and dosage form from name
                        let (strength, dosageForm) = extractStrengthAndForm(from: property.name)
                        
                        formulations.append(MedicationFormulation(
                            name: property.name,
                            rxcui: property.rxcui,
                            tty: property.tty ?? "",
                            strength: strength,
                            dosageForm: dosageForm
                        ))
                    }
                }
            }
        }
        
        // Remove duplicates and sort
        let uniqueFormulations = Dictionary(grouping: formulations) { $0.displayName.lowercased() }
            .compactMapValues { $0.first }
            .values
            .sorted { $0.displayName < $1.displayName }
        
        return Array(uniqueFormulations.prefix(10))
    }
    
    private func parseStrengths(_ response: RelatedResponse) -> [MedicationStrengthOption] {
        guard let relatedGroup = response.relatedGroup else { return [] }
        
        var strengths: [MedicationStrengthOption] = []
        
        if let conceptGroup = relatedGroup.conceptGroup {
            for group in conceptGroup {
                if let conceptProperties = group.conceptProperties {
                    for property in conceptProperties {
                        let (strengthValue, dosageForm) = extractStrengthAndForm(from: property.name)
                        
                        if let strength = strengthValue, let form = dosageForm {
                            // Try to extract brand name
                            let brandName = extractBrandName(from: property.name)
                            
                            strengths.append(MedicationStrengthOption(
                                strength: strength,
                                rxcui: property.rxcui,
                                dosageForm: form,
                                brandName: brandName
                            ))
                        }
                    }
                }
            }
        }
        
        // Remove duplicates and sort by strength
        let uniqueStrengths = Dictionary(grouping: strengths) { "\($0.strength)-\($0.dosageForm)" }
            .compactMapValues { $0.first }
            .values
            .sorted { $0.strength < $1.strength }
        
        return Array(uniqueStrengths.prefix(10))
    }
    
    // MARK: - Utility Methods
    
    private func extractStrengthAndForm(from name: String) -> (strength: String?, dosageForm: String?) {
        let components = name.components(separatedBy: " ")
        var strength: String?
        var dosageForm: String?
        
        // Look for strength patterns (numbers + mg/ml/mcg/etc.)
        for component in components {
            let lowercased = component.lowercased()
            if lowercased.contains("mg") || lowercased.contains("ml") || lowercased.contains("mcg") || lowercased.contains("iu") {
                strength = component
            }
        }
        
        // Look for common dosage forms
        let commonForms = ["tablet", "capsule", "injection", "solution", "suspension", "cream", "ointment", "gel", "patch", "inhaler"]
        for component in components {
            if commonForms.contains(component.lowercased()) {
                dosageForm = component.lowercased()
                break
            }
        }
        
        return (strength, dosageForm)
    }
    
    private func extractBrandName(from name: String) -> String? {
        // Simple brand name extraction - take the first word if it's capitalized
        let components = name.components(separatedBy: " ")
        if let first = components.first,
           first.first?.isUppercase == true,
           !first.lowercased().contains("mg"),
           !first.lowercased().contains("ml") {
            return first
        }
        return nil
    }
}

// MARK: - Enhanced Response Models

struct EnhancedDrugsResponse: Codable {
    let drugGroup: EnhancedDrugGroup?
}

struct EnhancedDrugGroup: Codable {
    let conceptGroup: [EnhancedConceptGroup]?
}

struct EnhancedConceptGroup: Codable {
    let tty: String?
    let conceptProperties: [EnhancedConceptProperty]?
}

struct EnhancedConceptProperty: Codable {
    let rxcui: String
    let name: String
    let synonym: String?
    let tty: String?
    let language: String?
    let suppress: String?
    let umlscui: String?
}

struct RelatedResponse: Codable {
    let relatedGroup: RelatedGroup?
}

struct RelatedGroup: Codable {
    let conceptGroup: [RelatedConceptGroup]?
}

struct RelatedConceptGroup: Codable {
    let tty: String?
    let conceptProperties: [RelatedConceptProperty]?
}

struct RelatedConceptProperty: Codable {
    let rxcui: String
    let name: String
    let synonym: String?
    let tty: String?
    let language: String?
    let suppress: String?
    let umlscui: String?
}
