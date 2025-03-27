//
//
// RootView.swift

// RootView.swift
// aura
//
// Created by Ella A. Sadduq on 3/27/25.
//

// RootView.swift

import SwiftUI

struct RootView: View {
    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        Group {
            if authVM.isLoading {
                ProgressView("Loading...")
            } else if AuthSettings.shared.isUserLoggedIn {
                // User is logged in, navigate to the main part of the app
                Text("🌟 User is signed in")
            } else {
                // User is not signed in, show login or sign up
                Text("🔐 User not signed in")
            }
        }
        .onAppear {
            // This will ensure session-related state is loaded on launch
            AuthSettings.shared.loadSessionSettings()
        }
    }
}

#Preview {
    RootView()
        .environmentObject(AuthViewModel.shared)
}
