//
//  ActionsStepView.swift
//  aura
//
//  Created by Ella A. Sadduq on 5/22/25.
//


//
//  ActionsStepView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/28/25.
//

import SwiftUI

struct ActionsStepView: View {
    @ObservedObject var diaryEntry: DiaryEntryViewModel
    @State private var selfHarmUrges: Double = 0
    @State private var suicidalThoughts: Double = 0
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header section
                VStack(spacing: 8) {
                    Image(systemName: DiaryStep.actions.systemImage)
                        .font(.largeTitle)
                        .foregroundColor(.orange)
                    
                    Text(DiaryStep.actions.title)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(DiaryStep.actions.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top)
                
                // Rating cards
                VStack(spacing: 16) {
                    RatingCardView(
                        title: "Self-harm urges",
                        description: "Rate the intensity of self-harm urges today",
                        value: $selfHarmUrges
                    )
                    .onChange(of: selfHarmUrges) { _, newValue in
                        diaryEntry.updateActionRating("selfHarmUrges", value: Int(newValue))
                    }
                    
                    RatingCardView(
                        title: "Suicidal thoughts",
                        description: "Rate the intensity of suicidal thoughts today",
                        value: $suicidalThoughts
                    )
                    .onChange(of: suicidalThoughts) { _, newValue in
                        diaryEntry.updateActionRating("suicidalThoughts", value: Int(newValue))
                    }
                }
                
                Spacer(minLength: 100)
            }
            .padding()
        }
        .onAppear {
            // Load existing values if any
            selfHarmUrges = Double(diaryEntry.diaryEntry.actions.selfHarmUrges.value)
            suicidalThoughts = Double(diaryEntry.diaryEntry.actions.suicidalThoughts.value)
        }
    }
}

#Preview {
    ActionsStepView(diaryEntry: DiaryEntryViewModel(session: .manual))
}