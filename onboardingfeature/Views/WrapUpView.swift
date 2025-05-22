//
//
//  WrapUpView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/30/25.
//

import SwiftUI

struct WrapUpView: View {
    @ObservedObject var onboardingVM = OnboardingViewModel.shared
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            // MARK: - Message
            Text("You're all set!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            Text("Let's begin your journey toward greater self-awareness and emotional well-being.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            // Show collected data for debugging
            if !onboardingVM.firstName.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Your Information:")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text("Name: \(onboardingVM.firstName) \(onboardingVM.lastName)")
                    Text("Age: \(onboardingVM.age)")
                    
                    if !onboardingVM.customActions.isEmpty {
                        Text("Custom Actions: \(onboardingVM.customActions.joined(separator: ", "))")
                    }
                    
                    if !onboardingVM.customGoals.isEmpty {
                        Text("Custom Goals: \(onboardingVM.customGoals.joined(separator: ", "))")
                    }
                }
                .font(.caption)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
            }
            
            // Show any error messages
            if !onboardingVM.errorMessage.isEmpty {
                Text(onboardingVM.errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }

            Spacer()

            // MARK: - Finish Button
            Button(action: {
                print("🎯 Finish button tapped")
                onboardingVM.completeOnboarding()
            }) {
                HStack {
                    if onboardingVM.isLoading {
                        ProgressView()
                            .scaleEffect(0.8)
                            .foregroundColor(.white)
                    }
                    
                    Text(onboardingVM.isLoading ? "Saving..." : "Finish")
                }
                .foregroundColor(.white)
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(onboardingVM.isLoading ? Color.gray : Color.accentColor)
                .cornerRadius(12)
                .padding(.horizontal)
            }
            .disabled(onboardingVM.isLoading)
        }
        .padding()
    }
}

#Preview {
    WrapUpView()
}
