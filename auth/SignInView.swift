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
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Logo or App Title
                Text("AURA")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Welcome Back")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Sign in to continue")
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                VStack(spacing: 15) {
                    TextField("Email", text: $email)
                        .modifier(AuthTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    SecureField("Password", text: $password)
                        .modifier(AuthTextFieldStyle())
                }
                .padding(.horizontal)
                
                // Error Message
                if let errorMessage = authVM.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                // Forgot Password Link
                HStack {
                    Spacer()
                    NavigationLink("Forgot Password?", destination: ForgotPasswordView())
                        .foregroundColor(.blue)
                }
                .padding(.horizontal)
                
                Button(action: {
                    Task {
                        isLoading = true
                        defer { isLoading = false }
                        await authVM.signInWithEmail(email: email, password: password)
                    }
                }) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Sign In")
                    }
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.horizontal)
                .disabled(isLoading)
                
                // Divider
                HStack {
                    Rectangle().fill(Color.gray.opacity(0.3)).frame(height: 1)
                    Text("OR").foregroundColor(.gray)
                    Rectangle().fill(Color.gray.opacity(0.3)).frame(height: 1)
                }
                .padding()
                
                // Social Login Buttons
                HStack(spacing: 20) {
                    Button(action: {}) {
                        Image(systemName: "g.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .foregroundColor(.red)
                    }
                    
                    Button(action: {}) {
                        Image(systemName: "apple.logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .foregroundColor(.black)
                    }
                }
                
                // Sign Up Navigation
                HStack {
                    Text("Don't have an account?")
                        .foregroundColor(.gray)
                    NavigationLink("Sign Up", destination: SignUpView())
                        .foregroundColor(.blue)
                }
                .padding()
            }
        }
    }
}

// Utility Styles (can be moved to a separate file)
struct AuthTextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

#Preview {
    SignInView()
        .environmentObject(AuthViewModel.shared)
}
