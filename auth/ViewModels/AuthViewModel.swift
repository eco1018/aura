

//
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
    @Published var authFlow: AuthFlowStep = .signIn
    
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
                    self.authFlow = .signIn
                    
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
            
            DispatchQueue.main.async {
                self?.user = user
                self?.isAuthenticated = true
                self?.loadUserProfile(uid: user.uid)
            }
        }
    }
    
    // MARK: - Sign Up
    func signUp(name: String, email: String, password: String) {
        print("📝 Attempting sign up for: \(email)")
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                print("❌ Sign up failed: \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user else { return }
            print("✅ Sign up successful for: \(user.uid)")
            
            // Create initial user profile for new user
            let newUser = UserProfile(uid: user.uid, name: name, email: email, hasCompletedOnboarding: false)
            
            newUser.save { success in
                DispatchQueue.main.async {
                    if success {
                        print("💾 Initial profile created for new user")
                        self?.user = user
                        self?.userProfile = newUser
                        self?.isAuthenticated = true
                        
                        // Ensure onboarding starts fresh for new user
                        OnboardingViewModel.shared.startFreshOnboarding()
                    } else {
                        print("❌ Failed to create initial profile")
                    }
                }
            }
        }
    }
    
    // MARK: - Load Profile
    func loadUserProfile(uid: String) {
        print("🔍 Loading profile for user: \(uid)")
        
        UserProfile.fetch(uid: uid) { [weak self] profile in
            DispatchQueue.main.async {
                if let profile = profile {
                    // Verify the profile belongs to the correct user
                    if profile.uid == uid {
                        self?.userProfile = profile
                        print("✅ Profile loaded for: \(profile.name) (UID: \(profile.uid))")
                        print("   - Completed onboarding: \(profile.hasCompletedOnboarding)")
                    } else {
                        print("⚠️ Profile UID mismatch! Expected: \(uid), Got: \(profile.uid)")
                        self?.userProfile = nil
                    }
                } else {
                    print("⚠️ No profile found for user: \(uid)")
                    self?.userProfile = nil
                }
            }
        }
    }
    
    // MARK: - Reset Password
    func resetPassword(email: String) {
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
                self.authFlow = .signIn
                
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
