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
        VStack {
            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocorrectionDisabled(true)

            SecureField("Password", text: $password)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            if let errorMessage = authVM.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            Button("Sign In") {
                Task {
                    await authVM.signInWithEmail()
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
    }
}

#Preview {
    SignInView()
        .environmentObject(AuthViewModel.shared)
}
