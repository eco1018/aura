
//
//  OnboardingViewModel.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/30/25.

import Foundation

// MARK: - Reminder Frequency Enum
enum ReminderFrequency {
    case once
    case twice
}

final class OnboardingViewModel: ObservableObject {
    static let shared = OnboardingViewModel()

    @Published var onboardingStep: OnboardingStep = .welcome
    @Published var hasCompletedOnboarding: Bool = false
    @Published var reminderFrequency: ReminderFrequency = .once

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
