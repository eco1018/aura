//
//  UserProfile.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/27/25.
//

import Foundation
import FirebaseFirestore

// Model to represent a user's profile
struct UserProfile: Identifiable, Codable {
    var id: String?  // Firestore's document ID (auto-generated)
    
    var firstName: String
    var lastName: String
    var age: Int
    var gender: String
    var email: String
    var createdAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName
        case lastName
        case age
        case gender
        case email
        case createdAt
    }
    
    // Initializer for the UserProfile
    init(firstName: String, lastName: String, age: Int, gender: String, email: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.gender = gender
        self.email = email
        self.createdAt = Date()
    }
    
    // Converting Firestore data to model object
    init(from document: DocumentSnapshot) throws {
        let data = document.data()
        self.id = document.documentID
        self.firstName = data?["firstName"] as? String ?? ""
        self.lastName = data?["lastName"] as? String ?? ""
        self.age = data?["age"] as? Int ?? 0
        self.gender = data?["gender"] as? String ?? ""
        self.email = data?["email"] as? String ?? ""
        self.createdAt = data?["createdAt"] as? Date
    }
}
