
//  AuthViewModel.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/27/25.
//

///
//  AuthViewModel.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/27/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
final class AuthViewModel: ObservableObject {
    static let shared = AuthViewModel()

    @Published var user: User?
    @Published var errorMessage: String?
    @Published var successMessage: String?

    init() {
        self.user = Auth.auth().currentUser
    }

    func fetchUserProfile() async {
        // Optional: implement later
    }

    func saveUserProfile(firstName: String, lastName: String, email: String) async {
        guard let uid = user?.uid else {
            self.errorMessage = "Missing user ID"
            return
        }

        let db = Firestore.firestore()
        let userData: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "createdAt": Timestamp()
        ]

        do {
            try await db.collection("users").document(uid).setData(userData)
            self.successMessage = "User profile saved!"
            print("✅ User profile saved to Firestore for UID: \(uid)")
        } catch {
            let authError = AuthError(from: error)
            self.errorMessage = authError.localizedDescription
        }
    }

    func signInWithEmail(email: String, password: String) async {
        errorMessage = nil
        successMessage = nil

        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.user = result.user
            await fetchUserProfile()
        } catch {
            let authError = AuthError(from: error)
            self.errorMessage = authError.localizedDescription
        }
    }

    func signUpWithEmail(email: String, password: String, confirmPassword: String, firstName: String, lastName: String) async {
        errorMessage = nil
        successMessage = nil

        guard password == confirmPassword else {
            self.errorMessage = "Passwords do not match"
            return
        }

        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.user = result.user
            await saveUserProfile(firstName: firstName, lastName: lastName, email: email)

            try await Auth.auth().currentUser?.reload()
            self.user = Auth.auth().currentUser
        } catch {
            let authError = AuthError(from: error)
            self.errorMessage = authError.localizedDescription
        }
    }

    func resetPassword(email: String) async {
        errorMessage = nil
        successMessage = nil

        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
            successMessage = "Password reset email sent successfully. Check your inbox."
        } catch {
            let authError = AuthError(from: error)
            self.errorMessage = authError.localizedDescription
        }
    }
}

enum AuthError: Error {
    case invalidEmail, wrongPassword, userNotFound
    case emailAlreadyInUse, weakPassword
    case invalidResetEmail, tooManyResetRequests
    case networkError, operationNotAllowed, unknownError

    init(from error: Error) {
        let nsError = error as NSError
        switch nsError.domain {
        case "FIRAuthErrorDomain":
            switch nsError.code {
            case AuthErrorCode.invalidEmail.rawValue: self = .invalidEmail
            case AuthErrorCode.wrongPassword.rawValue: self = .wrongPassword
            case AuthErrorCode.userNotFound.rawValue: self = .userNotFound
            case AuthErrorCode.emailAlreadyInUse.rawValue: self = .emailAlreadyInUse
            case AuthErrorCode.weakPassword.rawValue: self = .weakPassword
            case AuthErrorCode.tooManyRequests.rawValue: self = .tooManyResetRequests
            case AuthErrorCode.networkError.rawValue: self = .networkError
            case AuthErrorCode.operationNotAllowed.rawValue: self = .operationNotAllowed
            default: self = .unknownError
            }
        default:
            self = .unknownError
        }
    }

    var localizedDescription: String {
        switch self {
        case .invalidEmail: return "The email address is not valid. Please check and try again."
        case .wrongPassword: return "Incorrect password. Please try again."
        case .userNotFound: return "No account found with this email. Please sign up."
        case .emailAlreadyInUse: return "This email is already registered. Try logging in or use a different email."
        case .weakPassword: return "Password is too weak. Use at least 8 characters with uppercase, lowercase, and numbers."
        case .invalidResetEmail: return "The email address is invalid or does not exist."
        case .tooManyResetRequests: return "Too many reset attempts. Please wait before trying again."
        case .networkError: return "Network error. Please check your internet connection."
        case .operationNotAllowed: return "This operation is not allowed. Please contact support."
        case .unknownError: return "An unexpected error occurred. Please try again."
        }
    }
}
