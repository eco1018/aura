//
//  GoalsIntroView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/29/25.
//

//
//  GoalsIntroView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/29/25.
//

import SwiftUI

struct GoalsIntroView: View {
    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            // MARK: - Title
            Text("Let’s Focus on Your Goals")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            // MARK: - Description
            Text("""
            In DBT, goals help you stay on track and align your daily actions with what truly matters to you.

            This step will help you reflect on the goals you want to track — and give you a way to visualize your progress over time.
            """)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Spacer()

            // MARK: - Continue Button (UI-only)
            Button(action: {
                OnboardingViewModel.shared.goToNextStep()
            }) {
                Text("Next")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }
        }
        .padding()
    }
}

#Preview {
    GoalsIntroView()
}
