//
//  WelcomeView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/29/25.
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
        VStack(spacing: 24) {
            Spacer()
            
            // MARK: - Title
            Text("Welcome to Aura")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            // MARK: - Subtitle
            Text("Let’s build your emotional toolkit together.\nThis journey is yours, and we’ll go at your pace.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Spacer()
            
            // MARK: - Get Started Button (real)
            Button(action: {
                OnboardingViewModel.shared.goToNextStep()
            }) {
                Text("Get Started")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }
        }
        .padding()
    }
}

#Preview {
    WelcomeView()
}
