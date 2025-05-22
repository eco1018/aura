//
//  FirstNameView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/29/25.
//

import SwiftUI

struct FirstNameView: View {
    @ObservedObject var onboardingVM = OnboardingViewModel.shared

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            // MARK: - Prompt
            Text("What's your first name?")
                .font(.title)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)

            // MARK: - TextField
            TextField("Enter your first name", text: $onboardingVM.firstName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .autocapitalization(.words)

            Spacer()
            
            Button(action: {
                onboardingVM.goToNextStep()
            }) {
                Text("Next")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(onboardingVM.firstName.isEmpty ? Color.gray : Color.accentColor)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }
            .disabled(onboardingVM.firstName.isEmpty)
        }
        .padding()
    }
}

#Preview {
    FirstNameView()
}
