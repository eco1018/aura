//
//
//  EmotionsStepView.swift
//  aura
//
//  Created by Ella A. Sadduq on 5/22/25.
//

import SwiftUI

struct EmotionsStepView: View {
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
                        Text(DiaryStep.emotions.title)
                            .font(.system(size: 34, weight: .light, design: .default))
                            .foregroundColor(.primary.opacity(0.9))
                        
                        Text(DiaryStep.emotions.description)
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.secondary.opacity(0.7))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 80)
                    
                    Spacer()
                    
                    // Emotion cards using RatingCardView
                    VStack(spacing: 24) {
                        ForEach(diaryEntry.getAllEmotions(), id: \.key) { emotion in
                            RatingCardView(
                                title: emotion.title,
                                description: getEmotionDescription(emotion.title),
                                value: Binding(
                                    get: { Double(emotion.value.value) },
                                    set: { newValue in
                                        diaryEntry.updateEmotionRating(emotion.key, value: Int(newValue))
                                    }
                                )
                            )
                        }
                        
                        // If no emotions, show encouraging message
                        if diaryEntry.getAllEmotions().isEmpty {
                            VStack(spacing: 20) {
                                Text("No emotions selected")
                                    .font(.system(size: 19, weight: .medium))
                                    .foregroundColor(.primary.opacity(0.9))
                                
                                Text("You can select emotions to track during onboarding to monitor your emotional patterns here.")
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundColor(.secondary.opacity(0.6))
                                    .multilineTextAlignment(.center)
                            }
                            .padding(28)
                            .background(
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(Color(.systemBackground).opacity(0.8))
                                    .background(
                                        RoundedRectangle(cornerRadius: 24)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                                    .shadow(color: .black.opacity(0.04), radius: 20, x: 0, y: 8)
                                    .shadow(color: .black.opacity(0.02), radius: 1, x: 0, y: 1)
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
        .onAppear {
            print("🎭 EmotionsStepView appeared")
            print("   - Total emotions: \(diaryEntry.getAllEmotions().count)")
            print("   - Emotions list: \(diaryEntry.getAllEmotions().map { $0.title })")
        }
    }
    
    // MARK: - Helper Methods
    func getEmotionDescription(_ emotion: String) -> String {
        switch emotion.lowercased() {
        case "happy", "joy", "joyful":
            return "Rate how happy and cheerful you felt today"
        case "sad", "sadness":
            return "Rate how sad or down you felt today"
        case "angry", "anger", "mad":
            return "Rate how angry or irritated you felt today"
        case "anxious", "anxiety", "worried":
            return "Rate how anxious or nervous you felt today"
        case "calm", "peaceful", "relaxed":
            return "Rate how calm and peaceful you felt today"
        case "frustrated", "frustration":
            return "Rate how frustrated you felt today"
        case "excited", "excitement":
            return "Rate how excited you felt today"
        case "scared", "fear", "afraid":
            return "Rate how scared or fearful you felt today"
        case "grateful", "gratitude", "thankful":
            return "Rate how grateful you felt today"
        case "lonely", "loneliness":
            return "Rate how lonely you felt today"
        case "proud", "pride":
            return "Rate how proud you felt today"
        case "ashamed", "shame":
            return "Rate how ashamed you felt today"
        default:
            return "Rate how intensely you felt this emotion today"
        }
    }
}

#Preview {
    EmotionsStepView(diaryEntry: DiaryEntryViewModel(session: .manual))
}
