//
//
//  MedicationAPIService.swift
//  aura
//
//  Enhanced medication API with detailed medication selection

import Foundation

// MARK: - Enhanced Medication Models

struct DetailedMedicationSearchResult: Codable, Identifiable {
    let id = UUID()
    let rxcui: String
    let name: String
    let genericName: String?
    let strength: String?
    let dosageForm: String? // tablet, capsule, etc.
    let brandNames: [String]
    let isGeneric: Bool
    
    var displayName: String {
        if let strength = strength {
            return "\(name) \(strength)"
        }
        return name
    }
    
    var fullDescription: String {
        var components: [String] = [name]
        
        if let strength = strength {
            components.append(strength)
        }
        
        if let form = dosageForm {
            components.append(form)
        }
        
        if let generic = genericName, generic != name {
            components.append("(\(generic))")
        }
        
        return components.joined(separator: " ")
    }
}

struct MedicationStrength: Codable, Identifiable {
    let id = UUID()
    let strength: String
    let rxcui: String
    let dosageForm: String
    
    var displayText: String {
        return "\(strength) \(dosageForm)"
    }
}

// MARK: - Enhanced API Service Protocol
protocol EnhancedMedicationAPIServiceProtocol {
    func searchMedicationNames(query: String) async throws -> [String]
    func getMedicationDetails(name: String) async throws -> [DetailedMedicationSearchResult]
    func getMedicationStrengths(rxcui: String) async throws -> [MedicationStrength]
}

// MARK: - Enhanced RxNorm API Service
class EnhancedRxNormAPIService: EnhancedMedicationAPIServiceProtocol {
    private let baseURL = "https://rxnav.nlm.nih.gov/REST"
    private let session: URLSession
    
    init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15.0
        config.timeoutIntervalForResource = 30.0
        config.waitsForConnectivity = true
        self.session = URLSession(configuration: config)
    }
    
    // MARK: - Step 1: Search for medication names
    func searchMedicationNames(query: String) async throws -> [String] {
        let trimmedQuery = query.trimmingCharacters(in: .whitespaces)
        
        guard !trimmedQuery.isEmpty && trimmedQuery.count >= 2 else {
            throw MedicationAPIError.invalidQuery
        }
        
        guard let encodedQuery = trimmedQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw MedicationAPIError.invalidQuery
        }
        
        // Use drugs endpoint for cleaner name search
        let urlString = "\(baseURL)/drugs.json?name=\(encodedQuery)"
        guard let url = URL(string: urlString) else {
            throw MedicationAPIError.invalidURL
        }
        
        print("🔍 Searching medication names: \(urlString)")
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw MedicationAPIError.networkError
            }
            
            let decoder = JSONDecoder()
            let apiResponse = try decoder.decode(RxNormDrugsResponse.self, from: data)
            
            let names = parseDrugNames(apiResponse)
            print("✅ Found \(names.count) medication names")
            return names
            
        } catch {
            if error is MedicationAPIError {
                throw error
            } else {
                throw MedicationAPIError.networkError
            }
        }
    }
    
    // MARK: - Step 2: Get detailed medication info
    func getMedicationDetails(name: String) async throws -> [DetailedMedicationSearchResult] {
        guard let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw MedicationAPIError.invalidQuery
        }
        
        // Get RxCUIs for this drug name
        let urlString = "\(baseURL)/rxcui.json?name=\(encodedName)"
        guard let url = URL(string: urlString) else {
            throw MedicationAPIError.invalidURL
        }
        
        print("🔍 Getting details for: \(name)")
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw MedicationAPIError.networkError
            }
            
            let decoder = JSONDecoder()
            let rxcuiResponse = try decoder.decode(RxNormRxCUIResponse.self, from: data)
            
            var allMedications: [DetailedMedicationSearchResult] = []
            
            // Get details for each RXCUI
            if let rxcuis = rxcuiResponse.idGroup?.rxnormId {
                for rxcui in rxcuis.prefix(10) { // Limit to prevent too many API calls
                    if let medications = try? await getMedicationsByRxCUI(rxcui: rxcui) {
                        allMedications.append(contentsOf: medications)
                    }
                }
            }
            
            // Remove duplicates and sort
            let uniqueMedications = Array(Set(allMedications.map { $0.rxcui }))
                .compactMap { rxcui in allMedications.first { $0.rxcui == rxcui } }
                .sorted { $0.name < $1.name }
            
            print("✅ Found \(uniqueMedications.count) detailed medications")
            return uniqueMedications
            
        } catch {
            if error is MedicationAPIError {
                throw error
            } else {
                throw MedicationAPIError.networkError
            }
        }
    }
    
    // MARK: - Step 3: Get strengths for a specific medication
    func getMedicationStrengths(rxcui: String) async throws -> [MedicationStrength] {
        let urlString = "\(baseURL)/rxcui/\(rxcui)/related.json?tty=SBD+SCD"
        guard let url = URL(string: urlString) else {
            throw MedicationAPIError.invalidURL
        }
        
        print("🔍 Getting strengths for RXCUI: \(rxcui)")
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw MedicationAPIError.networkError
            }
            
            let decoder = JSONDecoder()
            let relatedResponse = try decoder.decode(RxNormRelatedResponse.self, from: data)
            
            let strengths = parseStrengths(relatedResponse)
            print("✅ Found \(strengths.count) strengths")
            return strengths
            
        } catch {
            if error is MedicationAPIError {
                throw error
            } else {
                throw MedicationAPIError.networkError
            }
        }
    }
    
    // MARK: - Private Helper Methods
    
    private func getMedicationsByRxCUI(rxcui: String) async throws -> [DetailedMedicationSearchResult] {
        let urlString = "\(baseURL)/rxcui/\(rxcui)/properties.json"
        guard let url = URL(string: urlString) else {
            throw MedicationAPIError.invalidURL
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                return []
            }
            
            let decoder = JSONDecoder()
            let propertiesResponse = try decoder.decode(RxNormPropertiesResponse.self, from: data)
            
            return parseDetailedMedications(propertiesResponse)
            
        } catch {
            return []
        }
    }
    
    private func parseDrugNames(_ response: RxNormDrugsResponse) -> [String] {
        guard let drugGroup = response.drugGroup,
              let conceptGroup = drugGroup.conceptGroup else {
            return []
        }
        
        var names: Set<String> = []
        
        for group in conceptGroup {
            if let conceptProperties = group.conceptProperties {
                for property in conceptProperties {
                    names.insert(property.name)
                }
            }
        }
        
        return Array(names).sorted().prefix(15).map { $0 }
    }
    
    private func parseDetailedMedications(_ response: RxNormPropertiesResponse) -> [DetailedMedicationSearchResult] {
        guard let properties = response.properties else { return [] }
        
        return properties.compactMap { property in
            // Extract strength and dosage form from name
            let (strength, dosageForm) = extractStrengthAndForm(from: property.name)
            
            return DetailedMedicationSearchResult(
                rxcui: property.rxcui,
                name: property.name,
                genericName: property.synonym,
                strength: strength,
                dosageForm: dosageForm,
                brandNames: [], // Would need additional API call
                isGeneric: property.tty?.contains("SCD") == true
            )
        }
    }
    
    private func parseStrengths(_ response: RxNormRelatedResponse) -> [MedicationStrength] {
        guard let relatedGroup = response.relatedGroup,
              let conceptGroup = relatedGroup.conceptGroup else {
            return []
        }
        
        var strengths: [MedicationStrength] = []
        
        for group in conceptGroup {
            if let conceptProperties = group.conceptProperties {
                for property in conceptProperties {
                    let (strength, dosageForm) = extractStrengthAndForm(from: property.name)
                    
                    if let strength = strength, let dosageForm = dosageForm {
                        strengths.append(MedicationStrength(
                            strength: strength,
                            rxcui: property.rxcui,
                            dosageForm: dosageForm
                        ))
                    }
                }
            }
        }
        
        return Array(Set(strengths.map { "\($0.strength)|\($0.dosageForm)" }))
            .compactMap { key in
                strengths.first { "\($0.strength)|\($0.dosageForm)" == key }
            }
            .sorted { $0.strength < $1.strength }
    }
    
    private func extractStrengthAndForm(from name: String) -> (strength: String?, dosageForm: String?) {
        let strengthPattern = #"(\d+(?:\.\d+)?\s*(?:mg|mcg|g|ml|units?))"#
        let formPattern = #"\b(tablet|capsule|injection|syrup|cream|ointment|patch|solution|suspension|extended.release|XR|IR|SR|ER)\b"#
        
        let strengthRegex = try? NSRegularExpression(pattern: strengthPattern, options: .caseInsensitive)
        let formRegex = try? NSRegularExpression(pattern: formPattern, options: .caseInsensitive)
        
        let range = NSRange(name.startIndex..<name.endIndex, in: name)
        
        let strength = strengthRegex?.firstMatch(in: name, options: [], range: range)
            .flatMap { Range($0.range, in: name) }
            .map { String(name[$0]) }
        
        let dosageForm = formRegex?.firstMatch(in: name, options: [], range: range)
            .flatMap { Range($0.range, in: name) }
            .map { String(name[$0]) }
        
        return (strength, dosageForm)
    }
}

// MARK: - Enhanced Response Models

struct RxNormDrugsResponse: Codable {
    let drugGroup: DrugGroup?
}

struct DrugGroup: Codable {
    let conceptGroup: [ConceptGroup]?
}

struct ConceptGroup: Codable {
    let tty: String?
    let conceptProperties: [ConceptProperty]?
}

struct ConceptProperty: Codable {
    let rxcui: String
    let name: String
    let synonym: String?
    let tty: String?
    let language: String?
    let suppress: String?
    let umlscui: String?
}

struct RxNormRxCUIResponse: Codable {
    let idGroup: IdGroup?
}

struct IdGroup: Codable {
    let rxnormId: [String]?
}

struct RxNormRelatedResponse: Codable {
    let relatedGroup: RelatedGroup?
}

struct RelatedGroup: Codable {
    let conceptGroup: [ConceptGroup]?
}

// MARK: - Keep existing simple models for compatibility
struct RxNormPropertiesResponse: Codable {
    let properties: [RxNormProperty]?
}

struct RxNormProperty: Codable {
    let rxcui: String
    let name: String
    let synonym: String?
    let tty: String?
}

// MARK: - API Errors (Updated)
enum MedicationAPIError: Error, LocalizedError {
    case invalidQuery
    case invalidURL
    case networkError
    case parsingError
    case noResults
    case rateLimited
    
    var errorDescription: String? {
        switch self {
        case .invalidQuery:
            return "Please enter at least 2 characters to search"
        case .invalidURL:
            return "Invalid search request"
        case .networkError:
            return "Please check your internet connection and try again"
        case .parsingError:
            return "Unable to process search results"
        case .noResults:
            return "No medications found for your search"
        case .rateLimited:
            return "Too many searches. Please wait a moment and try again"
        }
    }
}

// MARK: - Service Factory
class MedicationAPIServiceFactory {
    static func create() -> EnhancedMedicationAPIServiceProtocol {
        return EnhancedRxNormAPIService()
    }
    
    // Keep old interface for backward compatibility
    static func createSimple() -> MedicationAPIServiceProtocol {
        return SimpleRxNormAdapter()
    }
}

// MARK: - Adapter for backward compatibility
class SimpleRxNormAdapter: MedicationAPIServiceProtocol {
    private let enhancedService = EnhancedRxNormAPIService()
    
    func searchMedications(query: String) async throws -> [MedicationSearchResult] {
        let names = try await enhancedService.searchMedicationNames(query: query)
        return names.map { name in
            MedicationSearchResult(
                rxcui: UUID().uuidString, // Temporary
                name: name,
                synonym: nil,
                tty: nil
            )
        }
    }
    
    func getMedicationDetails(rxcui: String) async throws -> MedicationSearchResult? {
        return nil
    }
}
