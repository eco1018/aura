//
//
//  UrgesStepView.swift
//  aura
//
//  Created by Ella A. Sadduq on 5/22/25.
//

import SwiftUI

struct UrgesStepView: View {
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
                        Text(DiaryStep.urges.title)
                            .font(.system(size: 34, weight: .light, design: .default))
                            .foregroundColor(.primary.opacity(0.9))
                        
                        Text(DiaryStep.urges.description)
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.secondary.opacity(0.7))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 80)
                    
                    Spacer()
                    
                    // Urge cards using RatingCardView
                    VStack(spacing: 24) {
                        // Fixed urges
                        ForEach(fixedUrges, id: \.key) { urge in
                            RatingCardView(
                                title: urge.title,
                                description: getDescriptionFor(urge.key),
                                value: Binding(
                                    get: { Double(urge.value.value) },
                                    set: { newValue in
                                        diaryEntry.updateUrgeRating(urge.key, value: Int(newValue))
                                    }
                                )
                            )
                        }
                        
                        // Custom urges
                        ForEach(customUrges, id: \.key) { urge in
                            RatingCardView(
                                title: urge.title,
                                description: "Rate how intense this urge was today",
                                value: Binding(
                                    get: { Double(urge.value.value) },
                                    set: { newValue in
                                        diaryEntry.updateUrgeRating(urge.key, value: Int(newValue))
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
    var fixedUrges: [(key: String, title: String, value: IntensityRating)] {
        [
            ("selfHarmUrge", "Self-harm urge", diaryEntry.diaryEntry.urges.selfHarmUrge),
            ("suicideUrge", "Suicide urge", diaryEntry.diaryEntry.urges.suicideUrge),
            ("quitTherapyUrge", "Quit therapy urge", diaryEntry.diaryEntry.urges.quitTherapyUrge)
        ]
    }
    
    var customUrges: [(key: String, title: String, value: IntensityRating)] {
        diaryEntry.diaryEntry.urges.customUrges.map { (key: $0.key, title: $0.key, value: $0.value) }
    }
    
    func getDescriptionFor(_ key: String) -> String {
        switch key {
        case "selfHarmUrge":
            return "Rate the intensity of self-harm urges today"
        case "suicideUrge":
            return "Rate the intensity of suicidal urges today"
        case "quitTherapyUrge":
            return "Rate the intensity of urges to quit therapy/treatment today"
        default:
            return "Rate how intense this urge was today"
        }
    }
}

#Preview {
    UrgesStepView(diaryEntry: DiaryEntryViewModel(session: .manual))
}
