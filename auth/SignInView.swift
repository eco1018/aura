//
//  SignInView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/27/25.
//
import SwiftUI

struct SignInView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Sign In")
                .font(.largeTitle)
                .bold()

            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .textContentType(.emailAddress)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            SecureField("Password", text: $password)
                .textContentType(.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: {
                authVM.signIn(email: email, password: password)
            }) {
                Text("Sign In")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            Button(action: {
                authVM.authFlow = .signUp
            }) {
                Text("Don't have an account? Sign Up")
                    .font(.footnote)
                    .foregroundColor(.blue)
            }

            Button(action: {
                authVM.authFlow = .forgotPassword
            }) {
                Text("Forgot Password?")
                    .font(.footnote)
                    .foregroundColor(.blue)
            }
        }
        .padding()
    }
}

#Preview {
    SignInView()
        .environmentObject(AuthViewModel.shared)
}
