

//
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
                                
                                SecureField("Create a secure password", text: $password, onCommit: {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        isPasswordFocused = false
                                    }
                                })
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
                            }
                            
                            // Confirm Password Field
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Confirm Password")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.black.opacity(0.7))
                                    .tracking(0.3)
                                
                                SecureField("Confirm your password", text: $confirmPassword, onCommit: {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        isConfirmPasswordFocused = false
                                    }
                                })
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
                                        .animation(.easeInOut(duration: 0.2), value: isConfirmPasswordFocused || showPasswordMismatch),
                                    alignment: .bottom
                                )
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        isConfirmPasswordFocused = true
                                    }
                                }
                            }
                            
                            // Error Message
                            if showPasswordMismatch {
                                HStack {
                                    Text("Passwords do not match")
                                        .font(.system(size: 13, weight: .regular))
                                        .foregroundColor(.red)
                                        .tracking(0.1)
                                    
                                    Spacer()
                                }
                                .transition(.opacity.combined(with: .offset(y: -5)))
                            }
                        }
                        .padding(.horizontal, 40)
                        .padding(.bottom, 50)
                        
                        // Create Account Button
                        VStack(spacing: 24) {
                            Button(action: {
                                if password == confirmPassword {
                                    showPasswordMismatch = false
                                    authVM.signUp(name: "", email: email, password: password)
                                } else {
                                    showPasswordMismatch = true
                                }
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
                            .scaleEffect(showPasswordMismatch ? 0.98 : 1.0)
                            .animation(.easeInOut(duration: 0.1), value: showPasswordMismatch)
                            
                            // Sign In Link
                            Button(action: {
                                authVM.authFlow = .signIn
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
            }
        }
    }
}

#Preview {
    SignUpView()
        .environmentObject(AuthViewModel.shared)
}
