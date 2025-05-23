
//  LastNameView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/29/25.
//

import SwiftUI

struct LastNameView: View {
    @State private var lastNameInput: String = ""

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
            
            VStack(spacing: 60) {
                Spacer()
                
                // Elegant header
                VStack(spacing: 20) {
                    Text("And your last name?")
                        .font(.system(size: 28, weight: .light, design: .default))
                        .foregroundColor(.primary.opacity(0.9))
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)
                
                // Glassmorphic input card
                VStack(spacing: 24) {
                    TextField("Enter your last name", text: $lastNameInput)
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(.primary.opacity(0.9))
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(.systemBackground).opacity(0.8))
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                )
                                .shadow(color: .black.opacity(0.03), radius: 12, x: 0, y: 4)
                                .shadow(color: .black.opacity(0.01), radius: 1, x: 0, y: 1)
                        )
                        .autocapitalization(.words)
                        .disableAutocorrection(true)
                }
                .padding(.horizontal, 24)
                
                Spacer()
                
                // Standard next button (exact match to other onboarding views)
                Button(action: {
                    // 🚀 Save last name to profile later if needed
                    OnboardingViewModel.shared.goToNextStep()
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
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
    }
}

#Preview {
    LastNameView()
}
