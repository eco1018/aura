//
//  AppCoordinator.swift
//  aura
//
//  Created by Ella A. Sadduq on 6/28/25.
//
//
// AppCoordinator.swift
// aura
//
// STEP 2: Add this second file
// Still changes NOTHING in your existing app
// Just watches what's happening and logs it
//

import SwiftUI
import Combine

class AppCoordinator: ObservableObject {
    @Published var navigationState = NavigationState()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        startObserving()
    }
    
    private func startObserving() {
        // Watch AuthViewModel changes (but don't interfere)
        AuthViewModel.shared.$isAuthenticated
            .sink { [weak self] isAuthenticated in
                self?.logAuthState(isAuthenticated: isAuthenticated)
            }
            .store(in: &cancellables)
        
        // Watch OnboardingViewModel changes (but don't interfere)
        OnboardingViewModel.shared.$hasCompletedOnboarding
            .sink { [weak self] hasCompleted in
                self?.logOnboardingState(hasCompleted: hasCompleted)
            }
            .store(in: &cancellables)
    }
    
    private func logAuthState(isAuthenticated: Bool) {
        if isAuthenticated {
            print("🔐 AppCoordinator: User is authenticated")
            navigationState.pushScreen("authenticated")
        } else {
            print("🔐 AppCoordinator: User is NOT authenticated")
            navigationState.pushScreen("not_authenticated")
        }
    }
    
    private func logOnboardingState(hasCompleted: Bool) {
        if hasCompleted {
            print("📝 AppCoordinator: Onboarding completed")
            navigationState.pushScreen("onboarding_complete")
        } else {
            print("📝 AppCoordinator: Onboarding NOT completed")
            navigationState.pushScreen("onboarding_needed")
        }
    }
}
