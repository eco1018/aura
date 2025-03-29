//

//
//  AuthSettings.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/28/25.
//

import Foundation

final class AuthSettings: ObservableObject {

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
