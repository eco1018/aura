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

            // MARK: - Button (no navigation logic)
            Text("Next")
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(firstNameInput.isEmpty ? Color.gray : Color.accentColor)
                .cornerRadius(10)
                .padding(.horizontal)
        }
        .padding()
    }
}

#Preview {
    FirstNameView()
}
