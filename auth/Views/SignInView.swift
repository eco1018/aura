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
    @State private var isEmailFocused: Bool = false
    @State private var isPasswordFocused: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Clean white background
                Color.white
                    .ignoresSafeArea()
                
                // Subtle background elements
                Circle()
                    .fill(Color.gray.opacity(0.03))
                    .frame(width: 350, height: 350)
                    .offset(x: -120, y: -180)
                    .blur(radius: 45)
                
                Circle()
                    .fill(Color.blue.opacity(0.02))
                    .frame(width: 280, height: 280)
                    .offset(x: 140, y: 220)
                    .blur(radius: 35)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        Spacer(minLength: 100)
                        
                        // Header Section
                        VStack(spacing: 32) {
                            // Clean logo/icon
                            ZStack {
                                Circle()
                                    .fill(Color.black)
                                    .frame(width: 60, height: 60)
                                    .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 8)
                                
                                Image(systemName: "person.circle")
                                    .font(.system(size: 24, weight: .medium))
                                    .foregroundColor(.white)
                            }
                            
                            VStack(spacing: 12) {
                                Text("Welcome Back")
                                    .font(.system(size: 28, weight: .light, design: .default))
                                    .foregroundColor(.black)
                                    .tracking(0.5)
                                
                                Text("Sign in to continue")
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
                                
                                SecureField("Enter your password", text: $password, onCommit: {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        isPasswordFocused = false
                                    }
                                })
                                .textContentType(.password)
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
                        }
                        .padding(.horizontal, 40)
                        .padding(.bottom, 50)
                        
                        // Sign In Button
                        VStack(spacing: 32) {
                            Button(action: {
                                authVM.signIn(email: email, password: password)
                            }) {
                                Text("Sign In")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                                    .tracking(0.5)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 52)
                                    .background(Color.black)
                                    .clipShape(RoundedRectangle(cornerRadius: 26))
                                    .shadow(color: Color.black.opacity(0.15), radius: 15, x: 0, y: 8)
                            }
                            
                            // Secondary Actions
                            VStack(spacing: 20) {
                                // Forgot Password Link
                                Button(action: {
                                    authVM.authFlow = .forgotPassword
                                }) {
                                    Text("Forgot Password?")
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundColor(.black)
                                        .tracking(0.2)
                                }
                                
                                // Sign Up Link
                                Button(action: {
                                    authVM.authFlow = .signUp
                                }) {
                                    HStack(spacing: 6) {
                                        Text("Don't have an account?")
                                            .font(.system(size: 15, weight: .regular))
                                            .foregroundColor(.gray)
                                            .tracking(0.2)
                                        
                                        Text("Sign Up")
                                            .font(.system(size: 15, weight: .medium))
                                            .foregroundColor(.black)
                                            .tracking(0.2)
                                    }
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
    SignInView()
        .environmentObject(AuthViewModel.shared)
}
