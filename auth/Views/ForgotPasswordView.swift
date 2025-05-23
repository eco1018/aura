//
//
//  ForgotPasswordView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/27/25.
//

import SwiftUI

struct ForgotPasswordView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var email: String = ""
    @State private var isEmailFocused: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Clean white background
                Color.white
                    .ignoresSafeArea()
                
                // Subtle background elements
                Circle()
                    .fill(Color.gray.opacity(0.03))
                    .frame(width: 320, height: 320)
                    .offset(x: 100, y: -150)
                    .blur(radius: 40)
                
                Circle()
                    .fill(Color.orange.opacity(0.02))
                    .frame(width: 250, height: 250)
                    .offset(x: -90, y: 200)
                    .blur(radius: 30)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        Spacer(minLength: 120)
                        
                        // Header Section
                        VStack(spacing: 32) {
                            // Clean logo/icon
                            ZStack {
                                Circle()
                                    .fill(Color.black)
                                    .frame(width: 60, height: 60)
                                    .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 8)
                                
                                Image(systemName: "lock.rotation")
                                    .font(.system(size: 24, weight: .medium))
                                    .foregroundColor(.white)
                            }
                            
                            VStack(spacing: 16) {
                                Text("Reset Password")
                                    .font(.system(size: 28, weight: .light, design: .default))
                                    .foregroundColor(.black)
                                    .tracking(0.5)
                                
                                Text("Enter your email address and we'll send you a link to reset your password")
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(.gray)
                                    .tracking(0.2)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: false, vertical: true)
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
                        }
                        .padding(.horizontal, 40)
                        .padding(.bottom, 50)
                        
                        // Action Buttons
                        VStack(spacing: 24) {
                            // Send Reset Link Button
                            Button(action: {
                                authVM.resetPassword(email: email)
                            }) {
                                Text("Send Reset Link")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                                    .tracking(0.5)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 52)
                                    .background(Color.black)
                                    .clipShape(RoundedRectangle(cornerRadius: 26))
                                    .shadow(color: Color.black.opacity(0.15), radius: 15, x: 0, y: 8)
                            }
                            
                            // Return to Sign In Link
                            Button(action: {
                                authVM.authFlow = .signIn
                            }) {
                                HStack(spacing: 6) {
                                    Image(systemName: "arrow.left")
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(.black)
                                    
                                    Text("Return to Sign In")
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundColor(.black)
                                        .tracking(0.2)
                                }
                            }
                        }
                        .padding(.horizontal, 40)
                        .padding(.bottom, 80)
                        
                        Spacer(minLength: 40)
                    }
                }
            }
        }
    }
}

#Preview {
    ForgotPasswordView()
        .environmentObject(AuthViewModel.shared)
}
