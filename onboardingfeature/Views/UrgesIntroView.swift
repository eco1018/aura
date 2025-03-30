
//
//  UrgesIntroView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/29/25.
//

import SwiftUI

struct UrgesIntroView: View {
    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            // MARK: - Title
            Text("Let’s Reflect on Urges")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            // MARK: - Description
            Text("""
            In DBT, urges are the intense feelings or impulses we may experience during difficult moments.

            This step will help you reflect on the urges you want to track — to better understand them and work with them.

            We’ll start by focusing on 3 common urges, and you’ll also be able to customize them to fit your journey.
            """)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Spacer()

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
    UrgesIntroView()
}
