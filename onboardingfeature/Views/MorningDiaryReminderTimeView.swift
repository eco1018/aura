//
//  MorningDiaryReminderTimeView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/30/25.
//

//
//  MorningDiaryReminderTimeView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/30/25.
//

import SwiftUI

struct MorningDiaryReminderTimeView: View {
    @State private var morningReminder: Date = Date()

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            // MARK: - Title
            Text("Set Morning Reminder Time")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Text("Choose a time to be reminded to complete your morning Diary Card.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            // MARK: - Time Picker
            DatePicker("Morning Reminder", selection: $morningReminder, displayedComponents: .hourAndMinute)
                .labelsHidden()
                .padding(.horizontal)

            Spacer()

            Button(action: {
                // Save morningReminder if needed
                if OnboardingViewModel.shared.reminderFrequency == .once {
                    OnboardingViewModel.shared.goToNextStep() // skip evening
                } else {
                    OnboardingViewModel.shared.onboardingStep = .diaryReminderTimeEvening
                }
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
    MorningDiaryReminderTimeView()
}
