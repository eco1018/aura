//
//

//
//
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
        if !authVM.isAuthenticated {
            authFlowView(for: authVM.authFlow)
        } else if !onboardingVM.hasCompletedOnboarding {
            OnboardingFlowView()
        } else {
            MainView()
        }
    }

    @ViewBuilder
    private func authFlowView(for step: AuthFlowStep) -> some View {
        switch step {
        case .signIn:
            SignInView()
        case .signUp:
            SignUpView()
        case .forgotPassword:
            ForgotPasswordView()
        }
    }
}
