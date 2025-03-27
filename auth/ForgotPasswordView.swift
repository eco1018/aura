//
//  ForgotPasswordView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/27/25.
//

import SwiftUI
import FirebaseAuth

struct ForgotPasswordView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var email: String = ""
    @State private var isLoading = false
    @State private var showSuccessMessage = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // App Title
                Text("AURA")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Reset Password")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Enter your email to reset your password")
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                // Email Input
                TextField("Email", text: $email)
                    .modifier(AuthTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding(.horizontal)
                
                // Success or Error Message
                if showSuccessMessage {
                    Text("Password reset email sent!")
                        .foregroundColor(.green)
                        .font(.caption)
                } else if let errorMessage = authVM.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                // Reset Password Button
                Button(action: {
                    Task {
                        isLoading = true
                        defer { isLoading = false }
                        await authVM.resetPassword(email: email)
                        
                        // Check for success message
                        if authVM.successMessage != nil {
                            showSuccessMessage = true
                            email = "" // Clear email field
                        }
                    }
                }) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Reset Password")
                    }
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.horizontal)
                .disabled(isLoading)
                
                // Back to Sign In
                NavigationLink(destination: SignInView()) {
                    Text("Back to Sign In")
                        .foregroundColor(.blue)
                }
                .padding()
                
                Spacer()
            }
        }
    }
}

#Preview {
    ForgotPasswordView()
        .environmentObject(AuthViewModel.shared)
}
