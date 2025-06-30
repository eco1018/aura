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
    @StateObject private var authCoordinator = AuthCoordinator()
    @StateObject private var onboardingVM = OnboardingViewModel.shared
    
    var body: some View {
        Group {
            if !authCoordinator.authViewModel.isAuthenticated {
                AuthCoordinatorMainView()
                    .environmentObject(authCoordinator)
            } else if !onboardingVM.hasCompletedOnboarding {
                OnboardingFlowView()
                    .environmentObject(onboardingVM)
            } else {
                MainView()
                    .environmentObject(authCoordinator.authViewModel)
            }
        }
        .onReceive(onboardingVM.$hasCompletedOnboarding) { completed in
            if completed {
                print("🎯 Onboarding completion detected in RootView")
            }
        }
        .onAppear {
            print("📱 RootView appeared")
            print("   - Authenticated: \(authCoordinator.authViewModel.isAuthenticated)")
            print("   - Onboarding Complete: \(onboardingVM.hasCompletedOnboarding)")
            print("   - User Profile: \(authCoordinator.authViewModel.userProfile?.name ?? "nil")")
        }
    }
}

#Preview {
    RootView()
}
