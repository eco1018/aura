//
//  UserProfile.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/27/25.
//

import Foundation
import FirebaseFirestore

struct UserProfile: Identifiable, Codable {
    var id: String?  // Firestore document ID
    
    var firstName: String
    var lastName: String
    var email: String
    var age: Int?
    var gender: String?
    var profileImageUrl: String?
    var createdAt: Date?
    
    // Computed property for full name
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    // Validation Enum
    enum ValidationError: Error {
        case emptyFirstName
        case emptyLastName
        case invalidEmail
        case invalidAge
        
        var localizedDescription: String {
            switch self {
            case .emptyFirstName: return "First name cannot be empty"
            case .emptyLastName: return "Last name cannot be empty"
            case .invalidEmail: return "Invalid email format"
            case .invalidAge: return "Age must be between 0 and 120"
            }
        }
    }
    
    // Email validation method
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    // Validation method
    func validate() throws {
        guard !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw ValidationError.emptyFirstName
        }
        
        guard !lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw ValidationError.emptyLastName
        }
        
        guard isValidEmail(email) else {
            throw ValidationError.invalidEmail
        }
        
        if let age = age, age < 0 || age > 120 {
            throw ValidationError.invalidAge
        }
    }
    
    // Conversion to Firestore dictionary
    func toFirestoreData() -> [String: Any] {
        var data: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "createdAt": FieldValue.serverTimestamp()
        ]
        
        if let age = age {
            data["age"] = age
        }
        
        if let gender = gender {
            data["gender"] = gender
        }
        
        if let profileImageUrl = profileImageUrl {
            data["profileImageUrl"] = profileImageUrl
        }
        
        return data
    }
    
    // Initializer with validation
    init(firstName: String, lastName: String, email: String, age: Int? = nil, gender: String? = nil, profileImageUrl: String? = nil) throws {
        self.firstName = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        self.lastName = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
        self.email = email
        self.age = age
        self.gender = gender
        self.profileImageUrl = profileImageUrl
        self.createdAt = Date()
        
        // Validate the profile
        try validate()
    }
    
    // Initializer from Firestore document
    init(from document: DocumentSnapshot) throws {
        guard let data = document.data() else {
            throw NSError(domain: "UserProfileError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document is empty"])
        }
        
        self.id = document.documentID
        self.firstName = data["firstName"] as? String ?? ""
        self.lastName = data["lastName"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.age = data["age"] as? Int
        self.gender = data["gender"] as? String
        self.profileImageUrl = data["profileImageUrl"] as? String
        self.createdAt = (data["createdAt"] as? Timestamp)?.dateValue()
        
        // Validate the profile
        try validate()
    }
}

// Extension to AuthViewModel to work with the enhanced UserProfile
extension AuthViewModel {
    // Updated save user profile method
    func saveUserProfile(profile: UserProfile) async {
        guard let userId = user?.uid else {
            errorMessage = "User not authenticated"
            return
        }
        
        do {
            // Validate profile before saving
            try profile.validate()
            
            // Save to Firestore
            try await Firestore.firestore()
                .collection("users")
                .document(userId)
                .setData(profile.toFirestoreData(), merge: true)
            
            print("✅ Successfully saved user profile")
            successMessage = "Profile updated successfully"
        } catch let error as UserProfile.ValidationError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = "Failed to save profile: \(error.localizedDescription)"
            print("❌ Failed to save user profile: \(error.localizedDescription)")
        }
    }
    
    // Updated fetch user profile method
    func fetchUserProfile() async -> UserProfile? {
        guard let userId = user?.uid else {
            errorMessage = "User not authenticated"
            return nil
        }
        
        do {
            let document = try await Firestore.firestore()
                .collection("users")
                .document(userId)
                .getDocument()
            
            let profile = try UserProfile(from: document)
            return profile
        } catch {
            errorMessage = "Failed to fetch profile: \(error.localizedDescription)"
            print("❌ Error fetching user profile: \(error.localizedDescription)")
            return nil
        }
    }
}
