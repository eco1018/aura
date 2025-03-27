//
//  MainView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/27/25.
//

//
//  MainView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/27/25.
//

import SwiftUI
import FirebaseAuth

struct MainView: View {
    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        VStack(spacing: 24) {
            Text("Welcome to the Main App Screen")
                .font(.largeTitle)
                .padding()

            Button(action: {
                do {
                    try Auth.auth().signOut()
                    authVM.user = nil
                } catch {
                    print("❌ Failed to sign out: \(error.localizedDescription)")
                    authVM.errorMessage = "Error signing out. Please try again."
                }
            }) {
                Text("Log Out")
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }
        }
    }
}
