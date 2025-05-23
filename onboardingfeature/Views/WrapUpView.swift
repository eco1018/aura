//
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
                
                // Elegant congratulations header
                VStack(spacing: 24) {
                    Text("You're all set!")
                        .font(.system(size: 34, weight: .light, design: .default))
                        .foregroundColor(.primary.opacity(0.9))
                        .multilineTextAlignment(.center)
                    
                    Text("Let's begin your journey toward greater self-awareness and emotional well-being.")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.secondary.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
                .padding(.horizontal, 24)
                
               
                     
                
                Spacer()
                
                // Elegant finish button with loading state
                Button(action: {
                    print("🎯 Finish button tapped")
                    onboardingVM.completeOnboarding()
                }) {
                    HStack(spacing: 12) {
                        if onboardingVM.isLoading {
                            ProgressView()
                                .scaleEffect(0.8)
                                .foregroundColor(.white)
                        }
                        
                        Text(onboardingVM.isLoading ? "Saving..." : "Finish")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                        
                        if !onboardingVM.isLoading {
                            Image(systemName: "checkmark")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(onboardingVM.isLoading ? Color.secondary.opacity(0.4) : Color.primary.opacity(0.9))
                            .shadow(
                                color: onboardingVM.isLoading ? .clear : .black.opacity(0.15),
                                radius: onboardingVM.isLoading ? 0 : 12,
                                x: 0,
                                y: onboardingVM.isLoading ? 0 : 6
                            )
                            .shadow(
                                color: onboardingVM.isLoading ? .clear : .black.opacity(0.05),
                                radius: onboardingVM.isLoading ? 0 : 2,
                                x: 0,
                                y: onboardingVM.isLoading ? 0 : 1
                            )
                    )
                }
                .disabled(onboardingVM.isLoading)
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
                .animation(.easeInOut(duration: 0.2), value: onboardingVM.isLoading)
            }
        }
    }
}

#Preview {
    WrapUpView()
}
