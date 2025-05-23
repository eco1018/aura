
//  OnboardingFlowView.swift
import SwiftUI

struct OnboardingFlowView: View {
    @ObservedObject var onboardingVM = OnboardingViewModel.shared

    var body: some View {
        // Show current view directly without progress bar
        currentOnboardingView()
            .onAppear {
                print("📱 OnboardingFlowView appeared")
                print("   - Current step: \(onboardingVM.onboardingStep)")
                print("   - Has completed: \(onboardingVM.hasCompletedOnboarding)")
            }
            .onChange(of: onboardingVM.hasCompletedOnboarding) { _, completed in
                if completed {
                    print("🎯 Onboarding completed! Should transition to main app.")
                }
            }
    }

    @ViewBuilder
    private func currentOnboardingView() -> some View {
        switch onboardingVM.onboardingStep {
        case .welcome: WelcomeView()
        case .firstName: FirstNameView()
        case .lastName: LastNameView()
        case .birthdate: BirthdateView()
        case .diaryIntro: DiaryIntroView()
        case .actionsIntro: ActionsIntroView()
        case .actionsSelection: ActionsSelectionView()
        case .urgesIntro: UrgesIntroView()
        case .urgesSelection: UrgesSelectionView()
        case .goalsIntro: GoalsIntroView()
        case .goalsSelection: GoalsSelectionView()
        case .medicationsIntro: MedicationsIntroView()
        case .medicationsList: MedicationAddingView()
        case .medicationReminder: MedicationReminderView()
        case .diaryReminder: DiaryCardReminderView()
        case .diaryReminderTimeMorning: MorningDiaryReminderTimeView()
        case .diaryReminderTimeEvening: EveningDiaryReminderTimeView()
        case .wrapUp: WrapUpView()
        }
    }
}

#Preview {
    OnboardingFlowView()
}
