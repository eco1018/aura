//
//  OnboardingFlowView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/30/25.
//
//
//  OnboardingFlowView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/30/25.
//

import SwiftUI

struct OnboardingFlowView: View {
    @ObservedObject var onboardingVM = OnboardingViewModel.shared

    var body: some View {
        switch onboardingVM.onboardingStep {
        case .welcome:
            WelcomeView()
        case .firstName:
            FirstNameView()
        case .lastName:
            LastNameView()
        case .birthdate:
            BirthdateView()
        case .diaryIntro:
            DiaryIntroView()
        case .actionsIntro:
            ActionsIntroView()
        case .actionsSelection:
            ActionsSelectionView()
        case .urgesIntro:
            UrgesIntroView()
        case .urgesSelection:
            UrgesSelectionView()
        case .goalsIntro:
            GoalsIntroView()
        case .goalsSelection:
            GoalsSelectionView()
        case .medicationsIntro:
            MedicationIntroView()
        case .medicationsList:
            MedicationAddingView()
        case .medicationReminder:
            MedicationReminderView()
        case .diaryReminder:
            DiaryCardReminderView()
        case .diaryReminderTime:
            DiaryCardReminderTimeView()
        case .wrapUp:
            WrapUpView()
        }
    }
}
