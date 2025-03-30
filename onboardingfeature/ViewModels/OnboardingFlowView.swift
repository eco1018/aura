
//  OnboardingFlowView.swift
import SwiftUI

struct OnboardingFlowView: View {
    @ObservedObject var onboardingVM = OnboardingViewModel.shared

    var body: some View {
        VStack(spacing: 0) {
            // 🌿 Simple top progress bar
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle(tint: Color.accentColor))
                .frame(height: 4)
                .padding(.top, 4)

            // Show current view
            currentOnboardingView()
        }
    }

    private var progress: Double {
        guard let index = OnboardingStep.allCases.firstIndex(of: onboardingVM.onboardingStep) else {
            return 0.0
        }
        return Double(index + 1) / Double(OnboardingStep.allCases.count)
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
