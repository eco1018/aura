//
//  MedicationIntroView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/29/25.
//
//
//  MedicationIntroView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/29/25.
//

import SwiftUI

struct MedicationIntroView: View {
    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            // MARK: - Title
            Text("Let’s Talk About Medications")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            // MARK: - Description
            Text("""
            In DBT, tracking medications is an important part of understanding how they affect your emotional and mental well-being.

            If you take any medications, this step will help you track them. If not, no worries — we’ll skip this part.
            """)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Spacer()

            // MARK: - Continue Button (UI-only)
            Text("Continue")
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
    MedicationIntroView()
}
#Preview {
    MedicationIntroView()
}
