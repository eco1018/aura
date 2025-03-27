//
//  AuthViewModel.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/27/25.
//
// AuthViewModel.swift
import Foundation
import FirebaseAuth

@MainActor
final class AuthViewModel: ObservableObject {
    static let shared = AuthViewModel()

    @Published var user: User?
    @Published var isLoading = false

    private init() {
        self.user = Auth.auth().currentUser
    }
}
