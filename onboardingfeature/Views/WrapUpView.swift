//
//  WrapUpView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/29/25.
//
//
//  WrapUpView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/30/25.
//

import SwiftUI

struct WrapUpView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            // MARK: - Message
            Text("You're all set!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            Text("Let’s begin your journey toward greater self-awareness and emotional well-being.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Spacer()

            // MARK: - Finish Button
            Button(action: {
                OnboardingViewModel.shared.completeOnboarding()
            }) {
                Text("Finish")
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
    WrapUpView()
}
