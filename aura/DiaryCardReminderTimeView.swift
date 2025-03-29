//
//  DiaryCardReminderTimeView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/29/25.
//
//
//  DiaryCardReminderTimeView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/29/25.
//

import SwiftUI

struct DiaryCardReminderTimeView: View {
    @State private var morningReminder: Date = Date()
    @State private var eveningReminder: Date = Date()

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            // MARK: - Title
            Text("Set Your Diary Card Reminder Times")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            // MARK: - Description
            Text("""
            Now that you've selected when you’d like to complete your Diary Card, let’s set specific times for each reminder.

            Set a time for both your morning and evening reminders, or just choose one if you'd like to do it once per day.
            """)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            // MARK: - Morning Reminder Time Picker
            DatePicker("Morning Reminder", selection: $morningReminder, displayedComponents: .hourAndMinute)
                .labelsHidden()
                .padding(.horizontal)

            // MARK: - Evening Reminder Time Picker
            DatePicker("Evening Reminder", selection: $eveningReminder, displayedComponents: .hourAndMinute)
                .labelsHidden()
                .padding(.horizontal)

            Spacer()

            // MARK: - Continue Button
            Text("Continue")
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding(.horizontal)
        }
        .padding()
    }
}

#Preview {
    DiaryCardReminderTimeView()
}
