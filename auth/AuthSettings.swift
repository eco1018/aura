//
//  AuthSettings.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/28/25.
//
//
//  AuthSettings.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/27/25.

import Foundation

/// Handles onboarding step state + login session status
enum OnboardingStep {
    case start
    case profile
    case customize
    case complete
}

final class AuthSettings: ObservableObject {
    // Onboarding state
    @Published var onboardingStep: OnboardingStep = .start
    @Published var hasCompletedOnboarding: Bool = false

    // Session persistence
    @Published var isLoggedIn: Bool

    init() {
        self.isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
    }

    func logIn() {
        isLoggedIn = true
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
    }

    func logOut() {
        isLoggedIn = false
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
    }
}
