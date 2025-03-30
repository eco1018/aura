
//
//  EveningDiaryReminderTimeView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/30/25.
//

import SwiftUI

struct EveningDiaryReminderTimeView: View {
    @State private var eveningReminder: Date = Date()

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            // MARK: - Title
            Text("Set Evening Reminder Time")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Text("Choose a time to be reminded to complete your evening Diary Card.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            // MARK: - Time Picker
            DatePicker("Evening Reminder", selection: $eveningReminder, displayedComponents: .hourAndMinute)
                .labelsHidden()
                .padding(.horizontal)

            Spacer()

            Button(action: {
                // Save eveningReminder if needed
                OnboardingViewModel.shared.goToNextStep()
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
    EveningDiaryReminderTimeView()
}
