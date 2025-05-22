//
//
//
//  MedicationAPIService.swift
//  aura
//
//  Created by Assistant on 5/22/25.
//

import Foundation

// MARK: - Medication API Service Protocol
protocol MedicationAPIServiceProtocol {
    func searchMedications(query: String) async throws -> [MedicationSearchResult]
    func getMedicationDetails(rxcui: String) async throws -> MedicationSearchResult?
}

// MARK: - Real RxNorm API Service with Debug
class RxNormAPIService: MedicationAPIServiceProtocol {
    private let baseURL = "https://rxnav.nlm.nih.gov/REST"
    private let session = URLSession.shared
    
    func searchMedications(query: String) async throws -> [MedicationSearchResult] {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return []
        }
        
        // Encode the query for URL
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("❌ Failed to encode query: \(query)")
            throw MedicationAPIError.invalidQuery
        }
        
        // Build the search URL for approximate search
        let urlString = "\(baseURL)/approximateTerm.json?term=\(encodedQuery)&maxEntries=20"
        guard let url = URL(string: urlString) else {
            print("❌ Failed to create URL: \(urlString)")
            throw MedicationAPIError.invalidURL
        }
        
        print("🔍 Searching RxNorm API: \(urlString)")
        
        do {
            // Make the request with timeout
            let request = URLRequest(url: url, timeoutInterval: 10.0)
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Invalid response type")
                throw MedicationAPIError.networkError
            }
            
            print("📡 API Response Status: \(httpResponse.statusCode)")
            
            guard httpResponse.statusCode == 200 else {
                print("❌ RxNorm API Error: Status \(httpResponse.statusCode)")
                print("📄 Response data: \(String(data: data, encoding: .utf8) ?? "No data")")
                throw MedicationAPIError.networkError
            }
            
            // Print raw response for debugging
            if let responseString = String(data: data, encoding: .utf8) {
                print("📄 Raw API Response: \(responseString)")
            }
            
            // Parse the response
            do {
                let apiResponse = try JSONDecoder().decode(RxNormApproximateResponse.self, from: data)
                let results = parseApproximateResults(apiResponse)
                print("✅ Found \(results.count) medications from RxNorm")
                return results
            } catch {
                print("❌ Failed to parse RxNorm response: \(error)")
                print("📄 Response was: \(String(data: data, encoding: .utf8) ?? "No data")")
                throw MedicationAPIError.parsingError
            }
        } catch {
            print("❌ Network error: \(error)")
            throw MedicationAPIError.networkError
        }
    }
    
    func getMedicationDetails(rxcui: String) async throws -> MedicationSearchResult? {
        let urlString = "\(baseURL)/rxcui/\(rxcui)/properties.json"
        guard let url = URL(string: urlString) else {
            throw MedicationAPIError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw MedicationAPIError.networkError
        }
        
        do {
            let apiResponse = try JSONDecoder().decode(RxNormPropertiesResponse.self, from: data)
            return parsePropertiesResult(apiResponse)
        } catch {
            throw MedicationAPIError.parsingError
        }
    }
    
    // MARK: - Private Parsing Methods
    
    private func parseApproximateResults(_ response: RxNormApproximateResponse) -> [MedicationSearchResult] {
        print("🔍 Parsing response: \(response)")
        
        guard let candidates = response.approximateGroup?.candidate else {
            print("⚠️ No candidates found in response")
            return []
        }
        
        print("🔍 Found \(candidates.count) candidates")
        
        var results: [MedicationSearchResult] = []
        
        for candidate in candidates {
            print("🔍 Processing candidate: \(candidate.name) (RXCUI: \(candidate.rxcui))")
            let result = MedicationSearchResult(
                rxcui: candidate.rxcui,
                name: candidate.name,
                synonym: candidate.name,
                tty: nil
            )
            results.append(result)
        }
        
        return results
    }
    
    private func parsePropertiesResult(_ response: RxNormPropertiesResponse) -> MedicationSearchResult? {
        guard let properties = response.properties?.first else {
            return nil
        }
        
        return MedicationSearchResult(
            rxcui: properties.rxcui,
            name: properties.name,
            synonym: properties.synonym,
            tty: properties.tty
        )
    }
}

// MARK: - RxNorm API Response Models

struct RxNormApproximateResponse: Codable {
    let approximateGroup: ApproximateGroup?
    
    enum CodingKeys: String, CodingKey {
        case approximateGroup
    }
}

struct ApproximateGroup: Codable {
    let candidate: [RxNormCandidate]?
    
    enum CodingKeys: String, CodingKey {
        case candidate
    }
}

struct RxNormCandidate: Codable {
    let rxcui: String
    let name: String
    let score: String?
    
    enum CodingKeys: String, CodingKey {
        case rxcui
        case name
        case score
    }
}

struct RxNormPropertiesResponse: Codable {
    let properties: [RxNormProperty]?
}

struct RxNormProperty: Codable {
    let rxcui: String
    let name: String
    let synonym: String?
    let tty: String?
}

// MARK: - Enhanced Mock Service with Real Medications
class EnhancedMockMedicationAPIService: MedicationAPIServiceProtocol {
    
    // Comprehensive mock database
    private let mockMedications: [MedicationSearchResult] = [
        // Popular Brand Names
        MedicationSearchResult(rxcui: "1049221", name: "Advil", synonym: "Ibuprofen", tty: "BN"),
        MedicationSearchResult(rxcui: "1049589", name: "Tylenol", synonym: "Acetaminophen", tty: "BN"),
        MedicationSearchResult(rxcui: "1049640", name: "Aspirin", synonym: "Aspirin", tty: "IN"),
        MedicationSearchResult(rxcui: "1053652", name: "Prozac", synonym: "Fluoxetine", tty: "BN"),
        MedicationSearchResult(rxcui: "1094019", name: "Xanax", synonym: "Alprazolam", tty: "BN"),
        MedicationSearchResult(rxcui: "1094235", name: "Zoloft", synonym: "Sertraline", tty: "BN"),
        MedicationSearchResult(rxcui: "1097663", name: "Lipitor", synonym: "Atorvastatin", tty: "BN"),
        
        // Generic Names - Mental Health
        MedicationSearchResult(rxcui: "32967", name: "Sertraline", synonym: "Sertraline", tty: "IN"),
        MedicationSearchResult(rxcui: "42347", name: "Fluoxetine", synonym: "Fluoxetine", tty: "IN"),
        MedicationSearchResult(rxcui: "41127", name: "Escitalopram", synonym: "Escitalopram", tty: "IN"),
        MedicationSearchResult(rxcui: "2597", name: "Alprazolam", synonym: "Alprazolam", tty: "IN"),
        MedicationSearchResult(rxcui: "2624", name: "Lorazepam", synonym: "Lorazepam", tty: "IN"),
        MedicationSearchResult(rxcui: "39786", name: "Trazodone", synonym: "Trazodone", tty: "IN"),
        MedicationSearchResult(rxcui: "6470", name: "Lithium", synonym: "Lithium", tty: "IN"),
        MedicationSearchResult(rxcui: "42503", name: "Lamotrigine", synonym: "Lamotrigine", tty: "IN"),
        MedicationSearchResult(rxcui: "89013", name: "Quetiapine", synonym: "Quetiapine", tty: "IN"),
        MedicationSearchResult(rxcui: "73178", name: "Aripiprazole", synonym: "Aripiprazole", tty: "IN"),
        
        // Common Medical Conditions
        MedicationSearchResult(rxcui: "6809", name: "Metformin", synonym: "Metformin", tty: "IN"),
        MedicationSearchResult(rxcui: "29046", name: "Lisinopril", synonym: "Lisinopril", tty: "IN"),
        MedicationSearchResult(rxcui: "36567", name: "Atorvastatin", synonym: "Atorvastatin", tty: "IN"),
        MedicationSearchResult(rxcui: "153165", name: "Omeprazole", synonym: "Omeprazole", tty: "IN"),
        MedicationSearchResult(rxcui: "20610", name: "Amlodipine", synonym: "Amlodipine", tty: "IN"),
        MedicationSearchResult(rxcui: "35606", name: "Simvastatin", synonym: "Simvastatin", tty: "IN"),
        
        // Pain & Inflammation
        MedicationSearchResult(rxcui: "5640", name: "Ibuprofen", synonym: "Ibuprofen", tty: "IN"),
        MedicationSearchResult(rxcui: "161", name: "Acetaminophen", synonym: "Acetaminophen", tty: "IN"),
        MedicationSearchResult(rxcui: "1191", name: "Aspirin", synonym: "Aspirin", tty: "IN"),
        MedicationSearchResult(rxcui: "7052", name: "Naproxen", synonym: "Naproxen", tty: "IN"),
        
        // Sleep & Supplements
        MedicationSearchResult(rxcui: "141927", name: "Melatonin", synonym: "Melatonin", tty: "IN"),
        MedicationSearchResult(rxcui: "1190533", name: "Vitamin D", synonym: "Vitamin D", tty: "IN"),
        MedicationSearchResult(rxcui: "6038", name: "Magnesium", synonym: "Magnesium", tty: "IN"),
        
        // ADHD
        MedicationSearchResult(rxcui: "18631", name: "Methylphenidate", synonym: "Methylphenidate", tty: "IN"),
        MedicationSearchResult(rxcui: "1158447", name: "Adderall", synonym: "Amphetamine/Dextroamphetamine", tty: "BN"),
        
        // Blood Pressure
        MedicationSearchResult(rxcui: "50166", name: "Losartan", synonym: "Losartan", tty: "IN"),
        MedicationSearchResult(rxcui: "18867", name: "Metoprolol", synonym: "Metoprolol", tty: "IN"),
    ]
    
    func searchMedications(query: String) async throws -> [MedicationSearchResult] {
        print("🔄 Using enhanced mock service for query: \(query)")
        
        // Simulate realistic network delay
        try await Task.sleep(nanoseconds: 600_000_000) // 0.6 seconds
        
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return []
        }
        
        let lowercaseQuery = query.lowercased()
        
        let results = mockMedications.filter { medication in
            medication.name.lowercased().contains(lowercaseQuery) ||
            medication.synonym?.lowercased().contains(lowercaseQuery) == true
        }
        
        // Sort by relevance (exact matches first)
        let sortedResults = results.sorted { med1, med2 in
            let med1ExactMatch = med1.name.lowercased().hasPrefix(lowercaseQuery) ||
                                med1.synonym?.lowercased().hasPrefix(lowercaseQuery) == true
            let med2ExactMatch = med2.name.lowercased().hasPrefix(lowercaseQuery) ||
                                med2.synonym?.lowercased().hasPrefix(lowercaseQuery) == true
            
            if med1ExactMatch && !med2ExactMatch {
                return true
            } else if !med1ExactMatch && med2ExactMatch {
                return false
            } else {
                return med1.name < med2.name
            }
        }
        
        let finalResults = Array(sortedResults.prefix(15))
        print("✅ Enhanced mock found \(finalResults.count) results for: \(query)")
        return finalResults
    }
    
    func getMedicationDetails(rxcui: String) async throws -> MedicationSearchResult? {
        try await Task.sleep(nanoseconds: 300_000_000)
        return mockMedications.first { $0.rxcui == rxcui }
    }
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
            return "Invalid search query"
        case .invalidURL:
            return "Invalid API URL"
        case .networkError:
            return "Network request failed"
        case .parsingError:
            return "Failed to parse response"
        case .noResults:
            return "No medications found"
        case .rateLimited:
            return "Too many requests. Please try again later."
        }
    }
}

// MARK: - Service Factory with Fallback
class MedicationAPIServiceFactory {
    static func create() -> MedicationAPIServiceProtocol {
        // For debugging, let's use the enhanced mock first
        // This will work reliably while we debug the real API
        return EnhancedMockMedicationAPIService()
        
        // Switch back to real API when ready:
        // return RxNormAPIService()
    }
}
