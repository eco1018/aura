
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
            self.user = user
            self.isAuthenticated = (user != nil)
            
            if let uid = user?.uid {
                self.loadUserProfile(uid: uid)
                self.authFlow = .main
            } else {
                self.userProfile = nil
                self.authFlow = .signIn
            }
        }
    }
    
    // MARK: - Sign In
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                print("❌ Sign in failed: \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user else { return }
            DispatchQueue.main.async {
                self?.user = user
                self?.isAuthenticated = true
                self?.loadUserProfile(uid: user.uid)
                self?.authFlow = .main
            }
        }
    }
    
    // MARK: - Sign Up
    func signUp(name: String, email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                print("❌ Sign up failed: \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user else { return }
            let newUser = UserProfile(uid: user.uid, name: name, email: email)
            
            newUser.save { success in
                if success {
                    DispatchQueue.main.async {
                        self?.user = user
                        self?.userProfile = newUser
                        self?.isAuthenticated = true
                        self?.authFlow = .main
                    }
                }
            }
        }
    }
    
    // MARK: - Load Profile
    func loadUserProfile(uid: String) {
        UserProfile.fetch(uid: uid) { [weak self] profile in
            DispatchQueue.main.async {
                self?.userProfile = profile
            }
        }
    }
    
    // MARK: - Reset Password
    func resetPassword(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                print("❌ Password reset failed: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Sign Out
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.user = nil
            self.userProfile = nil
            self.isAuthenticated = false
            self.authFlow = .signIn
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

// MARK: - Auth Flow Enum
enum AuthFlowStep {
    case signIn
    case signUp
    case forgotPassword
    case main
}
