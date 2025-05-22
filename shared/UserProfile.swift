//
//
//
//
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
    
    // Medication support
    var takesMedications: Bool
    var medications: [Medication]
    var medicationProfileVersion: Int
    
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
         takesMedications: Bool = false,
         medications: [Medication] = [],
         medicationProfileVersion: Int = 1,
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
        self.takesMedications = takesMedications
        self.medications = medications
        self.medicationProfileVersion = medicationProfileVersion
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
        print("   - Takes Medications: \(takesMedications)")
        print("   - Medications Count: \(medications.count)")
        
        do {
            try db.collection("users").document(uid).setData(from: self) { error in
                if let error = error {
                    print("❌ Failed to save user: \(error.localizedDescription)")
                    completion?(false)
                } else {
                    print("✅ User profile saved successfully")
                    
                    // Save medication profile snapshot for historical tracking
                    if self.takesMedications && !self.medications.isEmpty {
                        self.saveMedicationSnapshot()
                    }
                    
                    completion?(true)
                }
            }
        } catch {
            print("❌ Encoding error: \(error.localizedDescription)")
            completion?(false)
        }
    }
    
    // MARK: - Medication Profile Snapshots
    
    private func saveMedicationSnapshot() {
        let db = Firestore.firestore()
        
        let snapshot = MedicationProfileSnapshot(
            userId: uid,
            medications: medications,
            version: medicationProfileVersion
        )
        
        do {
            try db.collection("users")
                .document(uid)
                .collection("medicationSnapshots")
                .document("version_\(medicationProfileVersion)")
                .setData(from: snapshot) { error in
                    if let error = error {
                        print("❌ Failed to save medication snapshot: \(error.localizedDescription)")
                    } else {
                        print("✅ Medication snapshot saved for version \(self.medicationProfileVersion)")
                    }
                }
        } catch {
            print("❌ Error saving medication snapshot: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Medication Helper Methods
    
    mutating func addMedication(_ medication: Medication) {
        // Check if medication already exists (by rxcui)
        if !medications.contains(where: { $0.rxcui == medication.rxcui }) {
            medications.append(medication)
            medicationProfileVersion += 1
            print("📦 Added medication: \(medication.displayName)")
        }
    }
    
    mutating func removeMedication(withId medicationId: String) {
        medications.removeAll { $0.id == medicationId }
        medicationProfileVersion += 1
        print("🗑️ Removed medication with ID: \(medicationId)")
    }
    
    mutating func updateMedication(_ updatedMedication: Medication) {
        if let index = medications.firstIndex(where: { $0.id == updatedMedication.id }) {
            medications[index] = updatedMedication
            medicationProfileVersion += 1
            print("🔄 Updated medication: \(updatedMedication.displayName)")
        }
    }
    
    var activeMedications: [Medication] {
        return medications.filter { $0.isActive }
    }
}
