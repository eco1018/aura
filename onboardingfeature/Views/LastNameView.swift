//
//  LastNameView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/29/25.
//
//
//  LastNameView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/29/25.
//

import SwiftUI

struct LastNameView: View {
    @State private var lastNameInput: String = ""

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            // MARK: - Prompt
            Text("And your last name?")
                .font(.title)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)

            // MARK: - TextField
            TextField("Enter your last name", text: $lastNameInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .autocapitalization(.words)

            Spacer()

            // MARK: - Button (no logic yet)
            Text("Next")
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(lastNameInput.isEmpty ? Color.gray : Color.accentColor)
                .cornerRadius(10)
                .padding(.horizontal)
        }
        .padding()
    }
}

#Preview {
    LastNameView()
}
