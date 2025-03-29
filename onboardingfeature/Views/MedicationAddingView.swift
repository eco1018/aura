//

//
//  MedicationAddingView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/29/25.
//

import SwiftUI

struct MedicationAddingView: View {
    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            // MARK: - Title
            Text("Add Your Medications")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            // MARK: - Description
            Text("""
            Let’s add the medications you take. This will help you keep track of when you take them and remind you to stay consistent.

            You can add the name of the medication and set reminder times for each one.
            """)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            // MARK: - Medication Name Input
            TextField("Enter medication name", text: .constant(""))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .autocapitalization(.words)

            // MARK: - Reminder Time Picker (for future reminder times)
            DatePicker("Set reminder time", selection: .constant(Date()), displayedComponents: .hourAndMinute)
                .labelsHidden()
                .padding(.horizontal)

            Spacer()

            // MARK: - Add Medication Button (UI-only)
            Text("Add Medication")
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding(.horizontal)

            // MARK: - Skip Button
            Button(action: {
                // Handle skip action here (navigate to next step)
            }) {
                Text("Skip this step")
                    .font(.body)
                    .foregroundColor(.gray)
            }
            .padding(.top, 8)
        }
        .padding()
    }
}

#Preview {
    MedicationAddingView()
}
