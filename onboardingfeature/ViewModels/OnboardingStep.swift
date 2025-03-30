

//
//  OnboardingStep.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/30/25.
//

import Foundation

/// Represents each screen in the onboarding flow.
enum OnboardingStep: Int, CaseIterable {
    case welcome
    case firstName
    case lastName
    case birthdate
    case diaryIntro
    case actionsIntro
    case actionsSelection
    case urgesIntro
    case urgesSelection
    case goalsIntro
    case goalsSelection
    case medicationsIntro
    case medicationsList
    case medicationReminder
    case diaryReminder
    case diaryReminderTimeMorning
    case diaryReminderTimeEvening
    case wrapUp
}
