//
//  FirstNameView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/29/25.
//

//
//  FirstNameView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/29/25.
//

import SwiftUI

struct FirstNameView: View {
    @State private var firstNameInput: String = ""

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            // MARK: - Prompt
            Text("What’s your first name?")
                .font(.title)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)

            // MARK: - TextField
            TextField("Enter your first name", text: $firstNameInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .autocapitalization(.words)

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
    FirstNameView()
}
