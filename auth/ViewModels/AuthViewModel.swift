

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
    @Published var userProfile: UserProfile?
    @Published var isAuthenticated: Bool = false
    @Published var isLoading: Bool = false
    @Published var authError: String?
    
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
                self.isLoading = false // Stop loading when auth state changes
                
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
        
        isLoading = true
        clearError()
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Sign in failed: \(error.localizedDescription)")
                    self?.handleAuthError(error)
                    return
                }
                
                guard let user = result?.user else {
                    self?.isLoading = false
                    return
                }
                print("✅ Sign in successful for: \(user.uid)")
                // isLoading will be set to false by auth state listener
            }
        }
    }
    
    // MARK: - Sign Up
    func signUp(name: String, email: String, password: String) {
        print("🔐 Attempting sign up for: \(email)")
        
        isLoading = true
        clearError()
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Sign up failed: \(error.localizedDescription)")
                    self?.handleAuthError(error)
                    return
                }
                
                guard let user = result?.user else {
                    self?.isLoading = false
                    return
                }
                
                print("✅ Sign up successful for: \(user.uid)")
                
                // Create user profile in Firestore
                self?.createUserProfile(uid: user.uid, name: name, email: email)
            }
        }
    }
    
    // MARK: - Create User Profile
    private func createUserProfile(uid: String, name: String, email: String) {
        let userProfile = UserProfile(
            uid: uid,
            name: name,
            email: email,
            hasCompletedOnboarding: false
        )
        
        let db = Firestore.firestore()
        
        do {
            try db.collection("users").document(uid).setData(from: userProfile) { [weak self] error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("❌ Failed to create user profile: \(error.localizedDescription)")
                        self?.authError = "Failed to create user profile"
                    } else {
                        print("✅ User profile created successfully")
                        self?.userProfile = userProfile
                    }
                    // isLoading will be set to false by auth state listener
                }
            }
        } catch {
            DispatchQueue.main.async {
                print("❌ Failed to encode user profile: \(error.localizedDescription)")
                self.authError = "Failed to create user profile"
                self.isLoading = false
            }
        }
    }
    
    // MARK: - Load User Profile
    private func loadUserProfile(uid: String) {
        let db = Firestore.firestore()
        
        db.collection("users").document(uid).getDocument { [weak self] document, error in
            if let error = error {
                print("❌ Failed to load user profile: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self?.userProfile = nil
                }
                return
            }
            
            guard let document = document, document.exists else {
                print("⚠️ User profile document does not exist")
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
        
        isLoading = true
        clearError()
        
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    print("❌ Password reset failed: \(error.localizedDescription)")
                    self?.handleAuthError(error)
                } else {
                    print("✅ Password reset email sent")
                }
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
                self.isLoading = false
                self.clearError()
                
                // Reset onboarding state
                OnboardingViewModel.shared.startFreshOnboarding()
            }
            
            print("✅ Sign out successful")
        } catch {
            print("❌ Sign out failed: \(error.localizedDescription)")
            DispatchQueue.main.async {
                self.authError = "Failed to sign out"
            }
        }
    }
    
    // MARK: - Error Handling
    private func handleAuthError(_ error: Error) {
        isLoading = false
        
        if let authError = error as? AuthErrorCode {
            switch authError.code {
            case .invalidEmail:
                self.authError = "Invalid email address"
            case .userNotFound:
                self.authError = "No account found with this email"
            case .wrongPassword:
                self.authError = "Incorrect password"
            case .emailAlreadyInUse:
                self.authError = "An account already exists with this email"
            case .weakPassword:
                self.authError = "Password is too weak"
            case .networkError:
                self.authError = "Network error. Please check your connection"
            case .tooManyRequests:
                self.authError = "Too many attempts. Please try again later"
            default:
                self.authError = error.localizedDescription
            }
        } else {
            self.authError = error.localizedDescription
        }
    }
    
    private func clearError() {
        authError = nil
    }
    
    deinit {
        if let handle = authHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
