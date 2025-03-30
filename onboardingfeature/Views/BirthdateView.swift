
//  BirthdateView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/29/25.
//

import SwiftUI

struct BirthdateView: View {
    @State private var birthdate: Date = Date()

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            // MARK: - Prompt
            Text("When’s your birthday?")
                .font(.title)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)

            // MARK: - Date Picker
            DatePicker("Select your birthdate", selection: $birthdate, displayedComponents: .date)
                .datePickerStyle(.wheel)
                .labelsHidden()
                .padding(.horizontal)

            Spacer()

            // MARK: - Next Button
            Button(action: {
                // 🚀 Save birthdate to profile here later if needed
                OnboardingViewModel.shared.goToNextStep()
            }) {
                Text("Next")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
        }
        .padding()
    }
}

#Preview {
    BirthdateView()
}
