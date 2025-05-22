//
//  UserProfile.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/27/25.
//
import Foundation
import FirebaseFirestore

struct UserProfile: Codable, Identifiable {
    @DocumentID var id: String?
    var uid: String
    var name: String
    var email: String
    var age: Int
    var gender: String
    
    var customActions: [String]
    var customUrges: [String]
    var customGoals: [String]
    var selectedEmotions: [String]
    
    var morningReminderTime: Date?
    var eveningReminderTime: Date?
    var hasCompletedOnboarding: Bool
    
    init(uid: String = "",
         name: String = "",
         email: String = "",
         age: Int = 0,
         gender: String = "",
         customActions: [String] = [],
         customUrges: [String] = [],
         customGoals: [String] = [],
         selectedEmotions: [String] = [],
         morningReminderTime: Date? = nil,
         eveningReminderTime: Date? = nil,
         hasCompletedOnboarding: Bool = false) {
        
        self.uid = uid
        self.name = name
        self.email = email
        self.age = age
        self.gender = gender
        self.customActions = customActions
        self.customUrges = customUrges
        self.customGoals = customGoals
        self.selectedEmotions = selectedEmotions
        self.morningReminderTime = morningReminderTime
        self.eveningReminderTime = eveningReminderTime
        self.hasCompletedOnboarding = hasCompletedOnboarding
    }
    
    // MARK: - Firestore Methods
    
    static func fetch(uid: String, completion: @escaping (UserProfile?) -> Void) {
        let db = Firestore.firestore()
        
        print("🔍 Fetching user profile for UID: \(uid)")
        
        db.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                print("❌ Failed to fetch user: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            do {
                if let user = try snapshot?.data(as: UserProfile.self) {
                    print("✅ User profile fetched successfully")
                    completion(user)
                } else {
                    print("⚠️ No user profile found, returning nil")
                    completion(nil)
                }
            } catch {
                print("❌ Decoding error: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    func save(completion: ((Bool) -> Void)? = nil) {
        let db = Firestore.firestore()
        
        print("🔍 Saving user profile:")
        print("   - UID: \(uid)")
        print("   - Name: \(name)")
        print("   - Email: \(email)")
        
        do {
            try db.collection("users").document(uid).setData(from: self) { error in
                if let error = error {
                    print("❌ Failed to save user: \(error.localizedDescription)")
                    completion?(false)
                } else {
                    print("✅ User profile saved successfully")
                    completion?(true)
                }
            }
        } catch {
            print("❌ Encoding error: \(error.localizedDescription)")
            completion?(false)
        }
    }
}
