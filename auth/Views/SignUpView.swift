

//
//
//  SignUpView.swift
//
//
//  SignUpView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/27/25.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var coordinator: AuthCoordinator
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showPasswordMismatch: Bool = false
    @State private var isNameFocused: Bool = false
    @State private var isEmailFocused: Bool = false
    @State private var isPasswordFocused: Bool = false
    @State private var isConfirmPasswordFocused: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Clean white background
                Color.white
                    .ignoresSafeArea()
                
                // Subtle background elements
                Circle()
                    .fill(Color.gray.opacity(0.03))
                    .frame(width: 400, height: 400)
                    .offset(x: 150, y: -200)
                    .blur(radius: 50)
                
                Circle()
                    .fill(Color.blue.opacity(0.02))
                    .frame(width: 300, height: 300)
                    .offset(x: -100, y: 250)
                    .blur(radius: 40)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        Spacer(minLength: 80)
                        
                        // Header Section
                        VStack(spacing: 32) {
                            // Clean logo/icon
                            ZStack {
                                Circle()
                                    .fill(Color.black)
                                    .frame(width: 60, height: 60)
                                    .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 8)
                                
                                Image(systemName: "person.crop.circle")
                                    .font(.system(size: 24, weight: .medium))
                                    .foregroundColor(.white)
                            }
                            
                            VStack(spacing: 12) {
                                Text("Create Account")
                                    .font(.system(size: 28, weight: .light, design: .default))
                                    .foregroundColor(.black)
                                    .tracking(0.5)
                                
                                Text("Join our community")
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(.gray)
                                    .tracking(0.2)
                            }
                        }
                        .padding(.bottom, 60)
                        
                        // Form Container
                        VStack(spacing: 32) {
                            // Name Field
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Full Name")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.black.opacity(0.7))
                                    .tracking(0.3)
                                
                                TextField("Enter your full name", text: $name, onEditingChanged: { focused in
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        isNameFocused = focused
                                    }
                                })
                                .autocapitalization(.words)
                                .textContentType(.name)
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.black)
                                .padding(.horizontal, 0)
                                .padding(.vertical, 16)
                                .background(Color.clear)
                                .overlay(
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundColor(isNameFocused ? .black : .gray.opacity(0.3))
                                        .animation(.easeInOut(duration: 0.2), value: isNameFocused),
                                    alignment: .bottom
                                )
                            }
                            
                            // Email Field
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Email")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.black.opacity(0.7))
                                    .tracking(0.3)
                                
                                TextField("Enter your email address", text: $email, onEditingChanged: { focused in
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        isEmailFocused = focused
                                    }
                                })
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .textContentType(.emailAddress)
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.black)
                                .padding(.horizontal, 0)
                                .padding(.vertical, 16)
                                .background(Color.clear)
                                .overlay(
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundColor(isEmailFocused ? .black : .gray.opacity(0.3))
                                        .animation(.easeInOut(duration: 0.2), value: isEmailFocused),
                                    alignment: .bottom
                                )
                            }
                            
                            // Password Field
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Password")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.black.opacity(0.7))
                                    .tracking(0.3)
                                
                                SecureField("Enter your password", text: $password)
                                    .textContentType(.newPassword)
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 0)
                                    .padding(.vertical, 16)
                                    .background(Color.clear)
                                    .overlay(
                                        Rectangle()
                                            .frame(height: 1)
                                            .foregroundColor(isPasswordFocused ? .black : .gray.opacity(0.3))
                                            .animation(.easeInOut(duration: 0.2), value: isPasswordFocused),
                                        alignment: .bottom
                                    )
                                    .onTapGesture {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            isPasswordFocused = true
                                        }
                                    }
                                    .onChange(of: password) { _ in
                                        checkPasswordMatch()
                                    }
                            }
                            
                            // Confirm Password Field
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Confirm Password")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.black.opacity(0.7))
                                    .tracking(0.3)
                                
                                SecureField("Confirm your password", text: $confirmPassword)
                                    .textContentType(.newPassword)
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 0)
                                    .padding(.vertical, 16)
                                    .background(Color.clear)
                                    .overlay(
                                        Rectangle()
                                            .frame(height: 1)
                                            .foregroundColor(
                                                showPasswordMismatch ? .red :
                                                (isConfirmPasswordFocused ? .black : .gray.opacity(0.3))
                                            )
                                            .animation(.easeInOut(duration: 0.2), value: isConfirmPasswordFocused),
                                        alignment: .bottom
                                    )
                                    .onTapGesture {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            isConfirmPasswordFocused = true
                                        }
                                    }
                                    .onChange(of: confirmPassword) { _ in
                                        checkPasswordMatch()
                                    }
                                
                                // Password mismatch warning
                                if showPasswordMismatch {
                                    Text("Passwords do not match")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.red)
                                        .tracking(0.1)
                                        .padding(.top, 4)
                                }
                            }
                        }
                        .padding(.horizontal, 40)
                        .padding(.bottom, 50)
                        
                        // Action Buttons
                        VStack(spacing: 32) {
                            // Sign Up Button
                            Button(action: {
                                coordinator.signUp(name: name, email: email, password: password, confirmPassword: confirmPassword)
                            }) {
                                Text("Create Account")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                                    .tracking(0.5)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 52)
                                    .background(Color.black)
                                    .clipShape(RoundedRectangle(cornerRadius: 26))
                                    .shadow(color: Color.black.opacity(0.15), radius: 15, x: 0, y: 8)
                            }
                            .disabled(coordinator.isLoading || showPasswordMismatch)
                            .scaleEffect(showPasswordMismatch ? 0.98 : 1.0)
                            .animation(.easeInOut(duration: 0.1), value: showPasswordMismatch)
                            
                            // Sign In Link
                            Button(action: {
                                coordinator.navigateTo(.signIn)
                            }) {
                                HStack(spacing: 6) {
                                    Text("Already have an account?")
                                        .font(.system(size: 15, weight: .regular))
                                        .foregroundColor(.gray)
                                        .tracking(0.2)
                                    
                                    Text("Sign In")
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundColor(.black)
                                        .tracking(0.2)
                                }
                            }
                        }
                        .padding(.horizontal, 40)
                        .padding(.bottom, 60)
                        
                        Spacer(minLength: 40)
                    }
                }
                
                // Loading overlay
                if coordinator.isLoading {
                    AuthLoadingOverlay()
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    private func checkPasswordMatch() {
        if !confirmPassword.isEmpty && password != confirmPassword {
            showPasswordMismatch = true
        } else {
            showPasswordMismatch = false
        }
    }
}

// MARK: - Loading Overlay (if not already defined in SignInView)
struct LoadingOverlaySignUp: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                ProgressView()
                    .scaleEffect(1.2)
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                
                Text("Creating account...")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.8))
            )
        }
    }
}

#Preview {
    SignUpView()
        .environmentObject(AuthCoordinator())
}
