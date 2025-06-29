//
//  GenderSelectionView.swift
//  aura
//
//  Created by Ella A. Sadduq on 6/29/25.
//


//
//  GenderSelectionView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/29/25.
//

import SwiftUI

struct GenderSelectionView: View {
    @ObservedObject var onboardingVM = OnboardingViewModel.shared
    @State private var customGender: String = ""
    
    let genderOptions = ["Male", "Female", "Non-binary", "Prefer not to say", "Other"]
    
    var body: some View {
        ZStack {
            // Premium gradient background
            LinearGradient(
                colors: [
                    Color(.systemGray6).opacity(0.1),
                    Color(.systemGray5).opacity(0.2),
                    Color(.systemGray6).opacity(0.15)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Elegant header
                VStack(spacing: 20) {
                    Text("Gender (Optional)")
                        .font(.system(size: 28, weight: .light, design: .default))
                        .foregroundColor(.primary.opacity(0.9))
                        .multilineTextAlignment(.center)
                    
                    Text("This helps us personalize your experience")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.secondary.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)
                
                // Gender option cards
                VStack(spacing: 16) {
                    ForEach(genderOptions, id: \.self) { option in
                        Button(action: {
                            if option == "Other" {
                                // Don't select "Other" directly, let user input custom text
                                return
                            } else {
                                onboardingVM.gender = option
                                customGender = ""
                            }
                        }) {
                            HStack(spacing: 20) {
                                // Selection indicator
                                Image(systemName: onboardingVM.gender == option ? "checkmark.circle.fill" : "circle")
                                    .font(.system(size: 20, weight: .light))
                                    .foregroundColor(onboardingVM.gender == option ? .primary.opacity(0.8) : .secondary.opacity(0.6))
                                    .frame(width: 28, height: 28)
                                
                                // Option text
                                Text(option)
                                    .font(.system(size: 17, weight: .regular))
                                    .foregroundColor(.primary.opacity(0.9))
                                
                                Spacer()
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(.systemBackground).opacity(0.8))
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                                    .shadow(color: .black.opacity(0.03), radius: 8, x: 0, y: 4)
                                    .shadow(color: .black.opacity(0.01), radius: 1, x: 0, y: 1)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        .disabled(option == "Other")
                        
                        // Custom input for "Other"
                        if option == "Other" {
                            HStack(spacing: 12) {
                                TextField("Please specify", text: $customGender)
                                    .font(.system(size: 16, weight: .regular))
                                    .padding(16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color(.systemBackground).opacity(0.8))
                                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                    )
                                    .onChange(of: customGender) { _, newValue in
                                        if !newValue.isEmpty {
                                            onboardingVM.gender = newValue
                                        }
                                    }
                                
                                Button(action: {
                                    if !customGender.trimmingCharacters(in: .whitespaces).isEmpty {
                                        onboardingVM.gender = customGender
                                    }
                                }) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 20, weight: .light))
                                        .foregroundColor(.primary.opacity(0.8))
                                }
                                .disabled(customGender.trimmingCharacters(in: .whitespaces).isEmpty)
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
                
                // Next/Skip buttons
                VStack(spacing: 16) {
                    // Next button (if gender selected)
                    if !onboardingVM.gender.isEmpty {
                        Button(action: {
                            print("📝 Gender selected: \(onboardingVM.gender)")
                            onboardingVM.goToNextStep()
                        }) {
                            HStack(spacing: 12) {
                                Text("Next")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.white)
                                
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                            }
                            .padding(20)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.primary.opacity(0.9))
                                    .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 6)
                                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                            )
                        }
                    }
                    
                    // Skip button
                    Button(action: {
                        onboardingVM.gender = "" // Clear any selection
                        print("📝 Gender skipped")
                        onboardingVM.goToNextStep()
                    }) {
                        Text("Skip")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.secondary.opacity(0.8))
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
    }
}

#Preview {
    GenderSelectionView()
}