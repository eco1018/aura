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
        ScrollView {
            VStack(spacing: 24) {
                // Header section
                VStack(spacing: 8) {
                    Image(systemName: DiaryStep.urges.systemImage)
                        .font(.largeTitle)
                        .foregroundColor(.red)
                    
                    Text(DiaryStep.urges.title)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(DiaryStep.urges.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top)
                
                // Rating cards for all urges (fixed + custom)
                VStack(spacing: 16) {
                    // Fixed urges section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Standard Tracking")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Text("Required for all users")
                                .font(.caption)
                                .foregroundColor(.red)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(Color.red.opacity(0.1))
                                .cornerRadius(4)
                        }
                        .padding(.horizontal)
                        
                        // Fixed urge cards
                        ForEach(fixedUrges, id: \.key) { urge in
                            UrgeRatingCard(
                                key: urge.key,
                                title: urge.title,
                                currentRating: urge.value.value,
                                onRatingChanged: { newValue in
                                    diaryEntry.updateUrgeRating(urge.key, value: newValue)
                                }
                            )
                        }
                    }
                    
                    // Custom urges section (if any)
                    if !customUrges.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Your Personal Tracking")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                                
                                Text("From your onboarding")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(4)
                            }
                            .padding(.horizontal)
                            
                            // Custom urge cards
                            ForEach(customUrges, id: \.key) { urge in
                                UrgeRatingCard(
                                    key: urge.key,
                                    title: urge.title,
                                    currentRating: urge.value.value,
                                    onRatingChanged: { newValue in
                                        diaryEntry.updateUrgeRating(urge.key, value: newValue)
                                    }
                                )
                            }
                        }
                    }
                }
                
                Spacer(minLength: 100)
            }
            .padding()
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
}

struct UrgeRatingCard: View {
    let key: String
    let title: String
    let currentRating: Int
    let onRatingChanged: (Int) -> Void
    
    @State private var sliderValue: Double
    
    init(key: String, title: String, currentRating: Int, onRatingChanged: @escaping (Int) -> Void) {
        self.key = key
        self.title = title
        self.currentRating = currentRating
        self.onRatingChanged = onRatingChanged
        self._sliderValue = State(initialValue: Double(currentRating))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Title and description
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.medium)
                
                Text(getDescriptionFor(key))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // Rating controls
            VStack(spacing: 8) {
                // Slider with labels
                HStack {
                    Text("0")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Slider(value: $sliderValue, in: 0...10, step: 1)
                        .tint(getColorFor(Int(sliderValue)))
                        .onChange(of: sliderValue) { _, newValue in
                            onRatingChanged(Int(newValue))
                        }
                    
                    Text("10")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // Current value display with intensity description
                HStack {
                    Text("Current rating: \(Int(sliderValue))")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text(getIntensityText(Int(sliderValue)))
                        .font(.caption)
                        .foregroundColor(getColorFor(Int(sliderValue)))
                        .fontWeight(.medium)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
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
    
    func getColorFor(_ value: Int) -> Color {
        switch value {
        case 0...2:
            return .green
        case 3...5:
            return .yellow
        case 6...7:
            return .orange
        case 8...10:
            return .red
        default:
            return .blue
        }
    }
    
    func getIntensityText(_ value: Int) -> String {
        switch value {
        case 0:
            return "None"
        case 1...2:
            return "Very Low"
        case 3...4:
            return "Low"
        case 5...6:
            return "Moderate"
        case 7...8:
            return "High"
        case 9...10:
            return "Very High"
        default:
            return ""
        }
    }
}

#Preview {
    UrgesStepView(diaryEntry: DiaryEntryViewModel(session: .manual))
}
