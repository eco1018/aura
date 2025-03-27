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

    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocorrectionDisabled(true)

            SecureField("Password", text: $password)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            SecureField("Confirm Password", text: $confirmPassword)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            if let errorMessage = authVM.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            Button("Sign Up") {
                Task {
                    await authVM.signUpWithEmail()
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
        .onChange(of: email, perform: { newValue in
            authVM.email = newValue
        })
        .onChange(of: password, perform: { newValue in
            authVM.password = newValue
        })
        .onChange(of: confirmPassword, perform: { newValue in
            authVM.confirmPassword = newValue
        })
    }
}

#Preview {
    SignUpView()
        .environmentObject(AuthViewModel.shared)
}
