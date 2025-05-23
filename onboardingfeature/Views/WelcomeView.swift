//
//  WelcomeView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/29/25.
//
//
//
//  WelcomeView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/29/25.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        ZStack {
            // Premium gradient background (exact MainView match)
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
                
                // Elegant header (exact MainView typography)
                VStack(spacing: 20) {
                    Text("Welcome")
                        .font(.system(size: 34, weight: .light, design: .default))
                        .foregroundColor(.primary.opacity(0.9))
                    
                    Text("Let's build your emotional toolkit together.\nThis journey is yours, and we'll go at your pace.")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.secondary.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 80)
                
                Spacer()
                
                // Standard button (exact MainView button style)
                Button(action: {
                    OnboardingViewModel.shared.goToNextStep()
                }) {
                    HStack(spacing: 12) {
                        Text("Get Started")
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
                .padding(.horizontal, 28)
                .padding(.bottom, 60)
            }
        }
    }
}

#Preview {
    WelcomeView()
}
