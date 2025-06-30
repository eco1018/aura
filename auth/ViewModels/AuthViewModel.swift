

//
//
//  AuthViewModel.swift
//  aura
//
//  AuthViewModel.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/27/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine

final class AuthViewModel: ObservableObject {
    
    // MARK: - Shared Instance
    static let shared = AuthViewModel()
    
    // MARK: - Published Properties
    @Published var user: User?
    @Published var userProfile: UserProfile? = nil
    @Published var isAuthenticated: Bool = false
    
    private var authHandle: AuthStateDidChangeListenerHandle?
    
    // MARK: - Init
    private init() {
        listenToAuthChanges()
    }
    
    // MARK: - Auth State Listener
    private func listenToAuthChanges() {
        authHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                let previousUserId = self.user?.uid
                let newUserId = user?.uid
                
                self.user = user
                self.isAuthenticated = (user != nil)
                
                if let uid = newUserId {
                    print("🔐 Auth state changed - User: \(uid)")
                    
                    // If this is a different user, clear previous profile
                    if previousUserId != newUserId {
                        print("👤 User changed from \(previousUserId ?? "nil") to \(uid)")
                        self.userProfile = nil
                        
                        // Reset onboarding for new user
                        OnboardingViewModel.shared.startFreshOnboarding()
                    }
                    
                    self.loadUserProfile(uid: uid)
                } else {
                    print("🚪 User signed out")
                    self.userProfile = nil
                    
                    // Reset onboarding when signing out
                    OnboardingViewModel.shared.startFreshOnboarding()
                }
            }
        }
    }
    
    // MARK: - Sign In
    func signIn(email: String, password: String) {
        print("🔐 Attempting sign in for: \(email)")
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                print("❌ Sign in failed: \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user else { return }
            print("✅ Sign in successful for: \(user.uid)")
        }
    }
    
    // MARK: - Sign Up
    func signUp(name: String, email: String, password: String) {
        print("🔐 Attempting sign up for: \(email)")
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                print("❌ Sign up failed: \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user else { return }
            print("✅ Sign up successful for: \(user.uid)")
            
            // Create user profile in Firestore
            self?.createUserProfile(uid: user.uid, name: name, email: email)
        }
    }
    
    // MARK: - Create User Profile
    private func createUserProfile(uid: String, name: String, email: String) {
        print("👤 Creating user profile for: \(uid)")
        
        let userProfile = UserProfile(
            uid: uid,
            name: name,
            email: email,
            hasCompletedOnboarding: false
        )
        
        let db = Firestore.firestore()
        
        do {
            try db.collection("users").document(uid).setData(from: userProfile) { [weak self] error in
                if let error = error {
                    print("❌ Failed to create user profile: \(error.localizedDescription)")
                } else {
                    print("✅ User profile created successfully")
                    
                    DispatchQueue.main.async {
                        self?.userProfile = userProfile
                    }
                }
            }
        } catch {
            print("❌ Failed to encode user profile: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Load User Profile
    private func loadUserProfile(uid: String) {
        print("👤 Loading user profile for: \(uid)")
        
        let db = Firestore.firestore()
        
        db.collection("users").document(uid).getDocument { [weak self] document, error in
            if let error = error {
                print("❌ Failed to load user profile: \(error.localizedDescription)")
                return
            }
            
            guard let document = document, document.exists else {
                print("⚠️ No profile found for user: \(uid)")
                DispatchQueue.main.async {
                    self?.userProfile = nil
                }
                return
            }
            
            do {
                let profile = try document.data(as: UserProfile.self)
                print("✅ User profile loaded: \(profile.name)")
                
                DispatchQueue.main.async {
                    // Verify the profile belongs to the current user
                    if profile.uid == uid {
                        self?.userProfile = profile
                    } else {
                        print("⚠️ Profile UID mismatch. Expected: \(uid), Got: \(profile.uid)")
                        self?.userProfile = nil
                    }
                }
            } catch {
                print("❌ Failed to decode user profile: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self?.userProfile = nil
                }
            }
        }
    }
    
    // MARK: - Reset Password
    func resetPassword(email: String) {
        print("🔑 Attempting password reset for: \(email)")
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                print("❌ Password reset failed: \(error.localizedDescription)")
            } else {
                print("✅ Password reset email sent")
            }
        }
    }
    
    // MARK: - Sign Out
    func signOut() {
        print("🚪 Signing out user")
        
        do {
            try Auth.auth().signOut()
            
            DispatchQueue.main.async {
                self.user = nil
                self.userProfile = nil
                self.isAuthenticated = false
                
                // Reset onboarding state
                OnboardingViewModel.shared.startFreshOnboarding()
            }
            
            print("✅ Sign out successful")
        } catch {
            print("❌ Sign out failed: \(error.localizedDescription)")
        }
    }
    
    deinit {
        if let handle = authHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
