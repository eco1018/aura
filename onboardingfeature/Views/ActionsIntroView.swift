//
//  ActionsIntroView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/29/25.
//
//
//  ActionsIntroView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/29/25.
//

import SwiftUI

struct ActionsIntroView: View {
    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            // MARK: - Title
            Text("Let’s Start with Actions")
                .font(.title)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            // MARK: - Description
            Text("""
            In DBT, “actions” are behaviors that often come up when we’re in distress.

            You’ll always track two common ones — **self-harm** and **suicidal thoughts** — and then choose a few more that feel personally relevant to you.

            These aren’t labels. They’re patterns — and the more aware we are, the more power we have to care for ourselves.
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
    ActionsIntroView()
}
