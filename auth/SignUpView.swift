//
//  SignUpView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/27/25.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Sign Up")
                .font(.largeTitle)
                .bold()

            TextField("Name", text: $name)
                .textContentType(.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .textContentType(.emailAddress)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            SecureField("Password", text: $password)
                .textContentType(.newPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: {
                authVM.signUp(name: name, email: email, password: password)
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
