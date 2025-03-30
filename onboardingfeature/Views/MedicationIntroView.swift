
//  MedicationsIntroView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/30/25.
//

import SwiftUI

struct MedicationsIntroView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            // MARK: - Intro Message
            Text("Many people find support through prescribed medications.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)

            // MARK: - Main Prompt
            Text("Do you take any daily medications?")
                .font(.title)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Spacer()

            // MARK: - Yes Button
            Button(action: {
                OnboardingViewModel.shared.onboardingStep = .medicationsList
            }) {
                Text("Yes")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }

            // MARK: - No Button
            Button(action: {
                OnboardingViewModel.shared.onboardingStep = .diaryReminder
            }) {
                Text("No")
                    .foregroundColor(.accentColor)
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.accentColor, lineWidth: 2)
                    )
                    .padding(.horizontal)
            }

            Spacer()
        }
        .padding()
    }
}

#Preview {
    MedicationsIntroView()
}
