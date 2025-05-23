
//  MedicationsIntroView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/30/25.
//

import SwiftUI

struct MedicationsIntroView: View {
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
                VStack(spacing: 24) {
                    
                    
                    Text("Do you take any daily medications?")
                        .font(.system(size: 28, weight: .light, design: .default))
                        .foregroundColor(.primary.opacity(0.9))
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)
                
                Spacer()
                
                // Elegant option buttons
                VStack(spacing: 24) {
                    // Yes button - Primary style
                    Button(action: {
                        OnboardingViewModel.shared.onboardingStep = .medicationsList
                    }) {
                        HStack(spacing: 12) {
                            Text("Yes")
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
                    
                    // No button - Secondary glassmorphic style
                    Button(action: {
                        OnboardingViewModel.shared.onboardingStep = .diaryReminder
                    }) {
                        HStack(spacing: 12) {
                            Text("No")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.primary.opacity(0.8))
                            
                            Image(systemName: "arrow.right")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.primary.opacity(0.6))
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(.systemBackground).opacity(0.8))
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                )
                                .shadow(color: .black.opacity(0.04), radius: 12, x: 0, y: 4)
                                .shadow(color: .black.opacity(0.02), radius: 1, x: 0, y: 1)
                        )
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
            }
        }
    }
}

#Preview {
    MedicationsIntroView()
}
