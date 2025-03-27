//
//  ForgotPasswordView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/27/25.
//

import SwiftUI

struct ForgotPasswordView: View {
    @EnvironmentObject var authVM: AuthViewModel

    @State private var email: String = "" // Local state to hold email value

    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocorrectionDisabled(true)
            
            Button("Reset Password") {
                Task {
                    await authVM.resetPassword(email: email) // Pass the email here
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)

            if let errorMessage = authVM.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .padding()
        .onChange(of: email) { newValue in
            authVM.email = newValue
        }
    }
}

#Preview {
    ForgotPasswordView()
        .environmentObject(AuthViewModel.shared)
}
