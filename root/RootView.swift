//
//

//
//
//
//  RootView.swift
//
//  RootView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/27/25.
//

import SwiftUI

struct RootView: View {
    @StateObject private var authVM = AuthViewModel.shared
    @StateObject private var onboardingVM = OnboardingViewModel.shared

    var body: some View {
        Group {
            if !authVM.isAuthenticated {
                authFlowView(for: authVM.authFlow)
            } else if !onboardingVM.hasCompletedOnboarding {
                OnboardingFlowView()
                    .environmentObject(onboardingVM)
            } else {
                MainView()
                    .environmentObject(authVM)
            }
        }
        .onReceive(onboardingVM.$hasCompletedOnboarding) { completed in
            if completed {
                print("🎯 Onboarding completion detected in RootView")
            }
        }
        .onAppear {
            print("📱 RootView appeared")
            print("   - Authenticated: \(authVM.isAuthenticated)")
            print("   - Onboarding Complete: \(onboardingVM.hasCompletedOnboarding)")
            print("   - User Profile: \(authVM.userProfile?.name ?? "nil")")
        }
    }

    @ViewBuilder
    private func authFlowView(for step: AuthFlowStep) -> some View {
        switch step {
        case .signIn:
            SignInView()
                .environmentObject(authVM)
        case .signUp:
            SignUpView()
                .environmentObject(authVM)
        case .forgotPassword:
            ForgotPasswordView()
                .environmentObject(authVM)
        }
    }
}

#Preview {
    RootView()
}
