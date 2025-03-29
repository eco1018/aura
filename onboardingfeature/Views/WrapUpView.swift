//
//  WrapUpView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/29/25.
//

//
//  WrapUpView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/29/25.
//

import SwiftUI

struct WrapUpView: View {
    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            // MARK: - Title
            Text("Beautiful Work!")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            // MARK: - Description
            Text("""
            You just created your personal tracking map. These choices will help guide your journey, and they’re completely yours — you can update them anytime.

            This is the beginning of noticing your patterns, honoring your progress, and building a life worth living.
            """)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Spacer()

            // MARK: - Continue Button
            Text("Finish")
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
    WrapUpView()
}
