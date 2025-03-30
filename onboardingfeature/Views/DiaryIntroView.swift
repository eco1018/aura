//
//  DiaryIntroView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/29/25.
//

//
//  DiaryIntroView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/29/25.
//

import SwiftUI

struct DiaryIntroView: View {
    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            // MARK: - Title
            Text("Let’s Personalize Your Diary Card")
                .font(.title)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            // MARK: - Message
            Text("""
            This part of the onboarding is where you’ll choose a few behaviors, urges, and goals that are most important for you to track in your healing journey.

            Don’t worry — there are no right or wrong answers. You can always update your choices later.

            Right now, we’ll help you gently reflect on what you want to keep an eye on each day.
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
    DiaryIntroView()
}
