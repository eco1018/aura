
//
//  DiaryCardReminderView.swift
//  DiaryCardReminderView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/29/25.

import SwiftUI

struct DiaryCardReminderView: View {
    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            // MARK: - Title
            Text("Set Your Diary Card Reminders")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            // MARK: - Description
            Text("""
            You can choose to complete your Diary Card once or twice a day.

            Reflecting on your day can help you track your progress and stay connected to your emotions and experiences.
            """)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            // MARK: - Reminder Options
            VStack(spacing: 16) {
                Button(action: {
                    // Save selection: once per day → go directly to evening time view
                    OnboardingViewModel.shared.reminderFrequency = .once
                    OnboardingViewModel.shared.onboardingStep = .diaryReminderTimeEvening
                }) {
                    Text("Once per day")
                        .font(.body)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }

                Button(action: {
                    // Save selection: twice per day → go to morning first
                    OnboardingViewModel.shared.reminderFrequency = .twice
                    OnboardingViewModel.shared.onboardingStep = .diaryReminderTimeMorning
                }) {
                    Text("Twice per day")
                        .font(.body)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
            }

            Spacer()
        }
        .padding()
    }
}

#Preview {
    DiaryCardReminderView()
}
