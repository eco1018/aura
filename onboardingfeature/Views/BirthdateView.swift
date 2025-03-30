
//  BirthdateView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/29/25.
//

import SwiftUI

struct BirthdateView: View {
    @State private var selectedAge: Int = 25

    let ageRange = Array(10...100) // Customize min/max age if needed

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            // MARK: - Prompt
            Text("What’s your age?")
                .font(.title)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)

            // MARK: - Age Picker
            Picker(selection: $selectedAge, label: Text("Age")) {
                ForEach(ageRange, id: \.self) { age in
                    Text("\(age)").tag(age)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(height: 150)
            .clipped()
            .padding(.horizontal)

            Spacer()

            // MARK: - Next Button
            Button(action: {
                // 🚀 Save age to profile later if needed
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
