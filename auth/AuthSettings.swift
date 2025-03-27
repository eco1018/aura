//
//  AuthSettings.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/27/25.
//
// AuthSettings.swift
// aura
//
// Created by Ella A. Sadduq on 3/27/25.
//
// AuthSettings.swift
import Foundation
import Combine // <-- Add Combine here

final class AuthSettings: ObservableObject {
    static let shared = AuthSettings()

    // Published properties to make them observable
    @Published var isUserLoggedIn: Bool = false
    @Published var rememberMe: Bool = false

    private let userDefaults = UserDefaults.standard // <-- Make sure UserDefaults is in scope

    // Initialize and load session settings
    private init() {
        loadSessionSettings()
    }

    // Load session-related settings from UserDefaults
    func loadSessionSettings() {
        self.isUserLoggedIn = userDefaults.bool(forKey: "isUserLoggedIn")
        self.rememberMe = userDefaults.bool(forKey: "rememberMe")
    }

    // Save session data to UserDefaults
    func saveSession(isLoggedIn: Bool, rememberMe: Bool) {
        userDefaults.set(isLoggedIn, forKey: "isUserLoggedIn")
        userDefaults.set(rememberMe, forKey: "rememberMe")
        self.isUserLoggedIn = isLoggedIn
        self.rememberMe = rememberMe
    }

    // Reset session data
    func resetSession() {
        userDefaults.removeObject(forKey: "isUserLoggedIn")
        userDefaults.removeObject(forKey: "rememberMe")
        self.isUserLoggedIn = false
        self.rememberMe = false
    }
}
