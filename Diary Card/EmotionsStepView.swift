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
        ScrollView {
            VStack(spacing: 24) {
                // Header section
                VStack(spacing: 8) {
                    Image(systemName: DiaryStep.emotions.systemImage)
                        .font(.largeTitle)
                        .foregroundColor(.pink)
                    
                    Text(DiaryStep.emotions.title)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(DiaryStep.emotions.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top)
                
                // Instruction
                Text("Rate how intensely you felt each emotion today:")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Emotion rating cards
                VStack(spacing: 16) {
                    ForEach(diaryEntry.getAllEmotions(), id: \.key) { emotion in
                        EmotionRatingCard(
                            emotion: emotion.title,
                            currentRating: emotion.value.value,
                            onRatingChanged: { newValue in
                                diaryEntry.updateEmotionRating(emotion.key, value: newValue)
                            }
                        )
                    }
                }
                
                // If no emotions, show encouraging message
                if diaryEntry.getAllEmotions().isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "heart.circle")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                        
                        Text("No emotions selected")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text("You can select emotions to track during onboarding to monitor your emotional patterns here.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.vertical, 40)
                }
                
                Spacer(minLength: 100)
            }
            .padding()
        }
        .onAppear {
            print("🎭 EmotionsStepView appeared")
            print("   - Total emotions: \(diaryEntry.getAllEmotions().count)")
            print("   - Emotions list: \(diaryEntry.getAllEmotions().map { $0.title })")
        }
    }
}

struct EmotionRatingCard: View {
    let emotion: String
    let currentRating: Int
    let onRatingChanged: (Int) -> Void
    
    @State private var sliderValue: Double
    
    init(emotion: String, currentRating: Int, onRatingChanged: @escaping (Int) -> Void) {
        self.emotion = emotion
        self.currentRating = currentRating
        self.onRatingChanged = onRatingChanged
        self._sliderValue = State(initialValue: Double(currentRating))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Emotion header with emoji
            HStack {
                Text(getEmotionEmoji(emotion))
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(emotion)
                        .font(.headline)
                        .fontWeight(.medium)
                    
                    Text(getEmotionDescription(emotion))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            // Rating controls
            VStack(spacing: 8) {
                // Slider with emotion-specific labels
                HStack {
                    Text("Not at all")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Slider(value: $sliderValue, in: 0...10, step: 1)
                        .tint(getEmotionColor(emotion))
                        .onChange(of: sliderValue) { _, newValue in
                            onRatingChanged(Int(newValue))
                        }
                    
                    Text("Extremely")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // Current value display
                HStack {
                    Text("Intensity: \(Int(sliderValue))/10")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text(getIntensityDescription(Int(sliderValue)))
                        .font(.caption)
                        .foregroundColor(getEmotionColor(emotion))
                        .fontWeight(.medium)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(getEmotionColor(emotion).opacity(0.05))
                .stroke(getEmotionColor(emotion).opacity(0.2), lineWidth: 1)
        )
    }
    
    func getEmotionEmoji(_ emotion: String) -> String {
        switch emotion.lowercased() {
        case "happy", "joy", "joyful":
            return "😊"
        case "sad", "sadness":
            return "😢"
        case "angry", "anger", "mad":
            return "😠"
        case "anxious", "anxiety", "worried":
            return "😰"
        case "calm", "peaceful", "relaxed":
            return "😌"
        case "frustrated", "frustration":
            return "😤"
        case "excited", "excitement":
            return "🤩"
        case "scared", "fear", "afraid":
            return "😨"
        case "grateful", "gratitude", "thankful":
            return "🙏"
        case "lonely", "loneliness":
            return "😔"
        case "proud", "pride":
            return "😌"
        case "ashamed", "shame":
            return "😳"
        default:
            return "💭"
        }
    }
    
    func getEmotionColor(_ emotion: String) -> Color {
        switch emotion.lowercased() {
        case "happy", "joy", "joyful":
            return .yellow
        case "sad", "sadness":
            return .blue
        case "angry", "anger", "mad":
            return .red
        case "anxious", "anxiety", "worried":
            return .orange
        case "calm", "peaceful", "relaxed":
            return .green
        case "frustrated", "frustration":
            return .red
        case "excited", "excitement":
            return .purple
        case "scared", "fear", "afraid":
            return .black
        case "grateful", "gratitude", "thankful":
            return .green
        case "lonely", "loneliness":
            return .gray
        case "proud", "pride":
            return .purple
        case "ashamed", "shame":
            return .brown
        default:
            return .blue
        }
    }
    
    func getEmotionDescription(_ emotion: String) -> String {
        switch emotion.lowercased() {
        case "happy", "joy", "joyful":
            return "Feeling cheerful and positive"
        case "sad", "sadness":
            return "Feeling down or melancholy"
        case "angry", "anger", "mad":
            return "Feeling irritated or upset"
        case "anxious", "anxiety", "worried":
            return "Feeling nervous or on edge"
        case "calm", "peaceful", "relaxed":
            return "Feeling at peace and centered"
        case "frustrated", "frustration":
            return "Feeling blocked or hindered"
        default:
            return "How intense was this emotion?"
        }
    }
    
    func getIntensityDescription(_ value: Int) -> String {
        switch value {
        case 0:
            return "Not felt"
        case 1...2:
            return "Barely noticeable"
        case 3...4:
            return "Mild"
        case 5...6:
            return "Moderate"
        case 7...8:
            return "Strong"
        case 9...10:
            return "Overwhelming"
        default:
            return ""
        }
    }
}

#Preview {
    EmotionsStepView(diaryEntry: DiaryEntryViewModel(session: .manual))
}
