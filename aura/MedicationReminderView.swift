
//
//  MedicationReminderView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/29/25.
//

import SwiftUI

struct MedicationReminderView: View {
    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            // MARK: - Title
            Text("Set Medication Reminders")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            // MARK: - Description
            Text("""
            Let’s set up reminders for your medication. You can choose a time in the morning and in the evening to make sure you take your meds consistently.
            """)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            // MARK: - Morning Reminder Time Picker
            DatePicker("Morning Reminder", selection: .constant(Date()), displayedComponents: .hourAndMinute)
                .labelsHidden()
                .padding(.horizontal)

            // MARK: - Evening Reminder Time Picker
            DatePicker("Evening Reminder", selection: .constant(Date()), displayedComponents: .hourAndMinute)
                .labelsHidden()
                .padding(.horizontal)

            Spacer()

            // MARK: - Continue Button (UI-only)
            Text("Save Reminders")
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
    MedicationReminderView()
}
