//
//
//
//
//
//
//
//
//  ActionsStepView.swift
//  aura
//
//  Created by Ella A. Sadduq on 5/22/25.
//

import SwiftUI

struct ActionsStepView: View {
    @ObservedObject var diaryEntry: DiaryEntryViewModel
    
    var body: some View {
        ZStack {
            // Same gradient background as MainView
            LinearGradient(
                colors: [
                    Color(.systemGray6).opacity(0.1),
                    Color(.systemGray5).opacity(0.2),
                    Color(.systemGray6).opacity(0.15)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 60) {
                    // Elegant header (same as MainView style)
                    VStack(spacing: 20) {
                        Text(DiaryStep.actions.title)
                            .font(.system(size: 34, weight: .light, design: .default))
                            .foregroundColor(.primary.opacity(0.9))
                        
                        Text(DiaryStep.actions.description)
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.secondary.opacity(0.7))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 80)
                    
                    Spacer()
                    
                    // Action cards using RatingCardView
                    VStack(spacing: 24) {
                        // Fixed actions
                        ForEach(fixedActions, id: \.key) { action in
                            RatingCardView(
                                title: action.title,
                                description: getDescriptionFor(action.key),
                                value: Binding(
                                    get: { Double(action.value.value) },
                                    set: { newValue in
                                        diaryEntry.updateActionRating(action.key, value: Int(newValue))
                                    }
                                )
                            )
                        }
                        
                        // Custom actions
                        ForEach(customActions, id: \.key) { action in
                            RatingCardView(
                                title: action.title,
                                description: "Rate how much you engaged in this behavior today",
                                value: Binding(
                                    get: { Double(action.value.value) },
                                    set: { newValue in
                                        diaryEntry.updateActionRating(action.key, value: Int(newValue))
                                    }
                                )
                            )
                        }
                    }
                    .padding(.horizontal, 28)
                    
                    Spacer()
                    
                    // Minimal date (same as MainView)
                    Text("Today is \(Date(), style: .date)")
                        .font(.system(size: 14, weight: .light))
                        .foregroundColor(.secondary.opacity(0.5))
                        .padding(.bottom, 60)
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    var fixedActions: [(key: String, title: String, value: IntensityRating)] {
        [
            ("selfHarm", "Self-harm", diaryEntry.diaryEntry.actions.selfHarm),
            ("suicide", "Suicide", diaryEntry.diaryEntry.actions.suicide)
        ]
    }
    
    var customActions: [(key: String, title: String, value: IntensityRating)] {
        diaryEntry.diaryEntry.actions.customActions.map { (key: $0.key, title: $0.key, value: $0.value) }
    }
    
    func getDescriptionFor(_ key: String) -> String {
        switch key {
        case "selfHarm":
            return "Did you engage in any self-harm behaviors today?"
        case "suicide":
            return "Did you attempt suicide or engage in suicidal behaviors today?"
        default:
            return "Rate how much you engaged in this behavior today"
        }
    }
}

#Preview {
    ActionsStepView(diaryEntry: DiaryEntryViewModel(session: .manual))
}
