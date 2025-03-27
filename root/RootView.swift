//
//
// RootView.swift

import SwiftUI

struct RootView: View {
    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        Group {
            if authVM.isLoading {
                ProgressView("Loading...")
            } else if authVM.user == nil {
                Text("🔐 User not signed in")
            } else {
                Text("🌟 User is signed in")
            }
        }
    }
}

#Preview {
    RootView()
        .environmentObject(AuthViewModel.shared)
}
