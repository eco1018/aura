
//
//  OnboardingViewModel.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/30/25.
//

import Foundation

final class OnboardingViewModel: ObservableObject {
    static let shared = OnboardingViewModel()

    @Published var onboardingStep: OnboardingStep = .welcome
    @Published var hasCompletedOnboarding: Bool = false

    // MARK: - Step Control
    func goToNextStep() {
        guard let currentIndex = OnboardingStep.allCases.firstIndex(of: onboardingStep),
              currentIndex + 1 < OnboardingStep.allCases.count else { return }

        onboardingStep = OnboardingStep.allCases[currentIndex + 1]
    }

    func goToPreviousStep() {
        guard let currentIndex = OnboardingStep.allCases.firstIndex(of: onboardingStep),
              currentIndex > 0 else { return }

        onboardingStep = OnboardingStep.allCases[currentIndex - 1]
    }

    func completeOnboarding() {
        hasCompletedOnboarding = true
        print("🎉 Onboarding complete!")
    }
}
