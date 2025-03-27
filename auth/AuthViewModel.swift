//
//  AuthViewModel.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/27/25.
//
// AuthViewModel.swift
// aura
//
// Created by Ella A. Sadduq on 3/27/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine

@MainActor
final class AuthViewModel: ObservableObject {
    static let shared = AuthViewModel()

    // 🔐 Login Credentials
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = "" // ✅ Added for SignUp
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var user: User?

    // 🧍 User Info for Onboarding
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var age: Int = 0
    @Published var gender: String = ""

    // 🧑‍💻 Firestore Profile Data
    @Published var userProfile: [String: Any] = [:]

    private var db = Firestore.firestore()

    // Initializing
    private init() {
        self.user = Auth.auth().currentUser
        Auth.auth().addStateDidChangeListener { _, user in
            self.user = user
            Task {
                await self.fetchUserProfile()
            }
        }
    }

    // 🔐 Sign In
    func signInWithEmail() async {
        isLoading = true
        errorMessage = nil
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.user = result.user
            await fetchUserProfile()
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    // ✍️ Sign Up
    func signUpWithEmail() async {
        isLoading = true
        errorMessage = nil
        
        // ✅ Match passwords before Firebase call
        guard password == confirmPassword else {
            self.errorMessage = "Passwords do not match"
            isLoading = false
            return
        }

        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.user = result.user
            await saveUserProfile()  // Save profile data after user is created
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    // 📥 Fetch User Profile from Firestore
    func fetchUserProfile() async {
        guard let userId = user?.uid else {
            return
        }

        let docRef = db.collection("users").document(userId)
        do {
            let snapshot = try await docRef.getDocument()
            if let data = snapshot.data() {
                userProfile = data
                // If you want to bind profile info to UI components
                firstName = data["firstName"] as? String ?? ""
                lastName = data["lastName"] as? String ?? ""
                age = data["age"] as? Int ?? 0
                gender = data["gender"] as? String ?? ""
            }
        } catch {
            print("❌ Error fetching user profile: \(error.localizedDescription)")
        }
    }

    // 📤 Save User Profile to Firestore
    func saveUserProfile() async {
        guard let userId = user?.uid else {
            return
        }

        let userData: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "age": age,
            "gender": gender,
            "email": email,
            "createdAt": FieldValue.serverTimestamp()
        ]

        do {
            try await db.collection("users").document(userId).setData(userData, merge: true)
            print("✅ Successfully saved user profile to Firestore")
        } catch {
            print("❌ Failed to save user profile: \(error.localizedDescription)")
        }
    }

    // 🔄 Reset Password
    func resetPassword(email: String) async {
        isLoading = true
        errorMessage = nil
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
            print("✅ Password reset email sent.")
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    // 🚪 Sign Out
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.user = nil
            firstName = ""
            lastName = ""
            age = 0
            gender = ""
            userProfile = [:]
            print("✅ Successfully signed out.")
        } catch {
            self.errorMessage = "Failed to sign out: \(error.localizedDescription)"
            print("❌ Error signing out: \(error.localizedDescription)")
        }
    }
}
