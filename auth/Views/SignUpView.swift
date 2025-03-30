

//
//  SignUpView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/27/25.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showPasswordMismatch: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Sign Up")
                .font(.largeTitle)
                .bold()

            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .textContentType(.emailAddress)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            SecureField("Password", text: $password)
                .textContentType(.newPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            SecureField("Confirm Password", text: $confirmPassword)
                .textContentType(.newPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            if showPasswordMismatch {
                Text("Passwords do not match")
                    .font(.footnote)
                    .foregroundColor(.red)
            }

            Button(action: {
                if password == confirmPassword {
                    showPasswordMismatch = false
                    authVM.signUp(name: "", email: email, password: password)
                } else {
                    showPasswordMismatch = true
                }
            }) {
                Text("Create Account")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            Button(action: {
                authVM.authFlow = .signIn
            }) {
                Text("Already have an account? Sign In")
                    .font(.footnote)
                    .foregroundColor(.blue)
            }
        }
        .padding()
    }
}

#Preview {
    SignUpView()
        .environmentObject(AuthViewModel.shared)
}
