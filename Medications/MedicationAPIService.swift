//
//
//  MedicationAPIService.swift
//  aura
//
//  Created by Ella A. Sadduq on 5/23/25.
//

//
//  MedicationAPIService.swift
//  aura
//
//  Enhanced medication API with detailed medication selection

import Foundation

// MARK: - Basic Medication Search Result (Keep for compatibility)
struct BasicMedicationSearchResult: Codable, Identifiable {
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

// MARK: - Basic API Service Protocol (Keep for compatibility)
protocol MedicationAPIServiceProtocol {
    func searchMedications(query: String) async throws -> [BasicMedicationSearchResult]
    func getMedicationDetails(rxcui: String) async throws -> BasicMedicationSearchResult?
}

// MARK: - Basic RxNorm API Service (Keep for compatibility)
class RxNormAPIService: MedicationAPIServiceProtocol {
    private let baseURL = "https://rxnav.nlm.nih.gov/REST"
    private let session: URLSession
    
    init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 10.0
        config.timeoutIntervalForResource = 20.0
        self.session = URLSession(configuration: config)
    }
    
    func searchMedications(query: String) async throws -> [BasicMedicationSearchResult] {
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
        
        print("🔍 Basic search: \(urlString)")
        
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
            let apiResponse = try decoder.decode(RxNormDrugsResponse.self, from: data)
            
            let results = parseMedicationSearchResults(apiResponse)
            print("✅ Basic search found \(results.count) results")
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
    
    func getMedicationDetails(rxcui: String) async throws -> BasicMedicationSearchResult? {
        let urlString = "\(baseURL)/rxcui/\(rxcui)/properties.json"
        guard let url = URL(string: urlString) else {
            throw MedicationAPIError.invalidURL
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                return nil
            }
            
            let decoder = JSONDecoder()
            let propertiesResponse = try decoder.decode(BasicPropertiesResponse.self, from: data)
            
            return parsePropertyToSearchResult(propertiesResponse)
            
        } catch {
            return nil
        }
    }
    
    private func parseMedicationSearchResults(_ response: RxNormDrugsResponse) -> [BasicMedicationSearchResult] {
        guard let drugGroup = response.drugGroup,
              let conceptGroup = drugGroup.conceptGroup else {
            return []
        }
        
        var results: [BasicMedicationSearchResult] = []
        
        for group in conceptGroup {
            if let conceptProperties = group.conceptProperties {
                for property in conceptProperties {
                    results.append(BasicMedicationSearchResult(
                        rxcui: property.rxcui,
                        name: property.name,
                        synonym: property.synonym,
                        tty: property.tty
                    ))
                }
            }
        }
        
        // Remove duplicates and limit results
        let uniqueResults = Dictionary(grouping: results) { $0.name }
            .compactMapValues { $0.first }
            .values
            .sorted { $0.name < $1.name }
        
        return Array(uniqueResults.prefix(20))
    }
    
    private func parsePropertyToSearchResult(_ response: BasicPropertiesResponse) -> BasicMedicationSearchResult? {
        guard let property = response.properties?.first else { return nil }
        
        return BasicMedicationSearchResult(
            rxcui: property.rxcui,
            name: property.name,
            synonym: property.synonym,
            tty: property.tty
        )
    }
}

// MARK: - Response Models for Basic Service
struct RxNormDrugsResponse: Codable {
    let drugGroup: BasicDrugGroup?
}

struct BasicDrugGroup: Codable {
    let conceptGroup: [BasicConceptGroup]?
}

struct BasicConceptGroup: Codable {
    let tty: String?
    let conceptProperties: [BasicConceptProperty]?
}

struct BasicConceptProperty: Codable {
    let rxcui: String
    let name: String
    let synonym: String?
    let tty: String?
    let language: String?
    let suppress: String?
    let umlscui: String?
}

struct BasicPropertiesResponse: Codable {
    let properties: [BasicProperty]?
}

struct BasicProperty: Codable {
    let rxcui: String
    let name: String
    let synonym: String?
    let tty: String?
}

// MARK: - API Errors
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
    
    var recoveryAdvice: String {
        switch self {
        case .invalidQuery:
            return "Try entering a longer medication name"
        case .invalidURL:
            return "Please try again"
        case .networkError:
            return "Check your connection and retry"
        case .parsingError:
            return "Please try a different search term"
        case .noResults:
            return "Try the generic name or different spelling"
        case .rateLimited:
            return "Wait 30 seconds before searching again"
        }
    }
}

// MARK: - Service Factory (Updated)
class MedicationAPIServiceFactory {
    // Basic service for backward compatibility
    static func create() -> MedicationAPIServiceProtocol {
        return RxNormAPIService()
    }
    
    // Enhanced service for new multi-step selection
    static func createEnhanced() -> EnhancedMedicationAPIService {
        return ProductionRxNormAPIService()
    }
}
