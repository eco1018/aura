//
//
//  SkillsStepView.swift
//  aura
//
//  Created by Ella A. Sadduq on 5/22/25.
//

import SwiftUI

struct SkillsStepView: View {
    @ObservedObject var diaryEntry: DiaryEntryViewModel
    @State private var skillEffectiveness: Double = 5.0
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header section
                VStack(spacing: 8) {
                    Image(systemName: DiaryStep.skills.systemImage)
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                    
                    Text(DiaryStep.skills.title)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Rate how effective your coping skills were today")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top)
                
                // Skills effectiveness rating card
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Skills Effectiveness")
                            .font(.headline)
                            .fontWeight(.medium)
                        
                        Text("How well did your DBT skills and coping strategies work for you today?")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    // Rating controls
                    VStack(spacing: 12) {
                        // Slider with labels
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("1")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                Text("Not effective")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Slider(value: $skillEffectiveness, in: 1...10, step: 1)
                                .tint(getEffectivenessColor(Int(skillEffectiveness)))
                                .onChange(of: skillEffectiveness) { _, newValue in
                                    diaryEntry.updateSkillEffectiveness(Int(newValue))
                                }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 2) {
                                Text("10")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                Text("Very effective")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        // Current value display with description
                        VStack(spacing: 8) {
                            HStack {
                                Text("Current rating: \(Int(skillEffectiveness))")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                Text(getEffectivenessDescription(Int(skillEffectiveness)))
                                    .font(.caption)
                                    .foregroundColor(getEffectivenessColor(Int(skillEffectiveness)))
                                    .fontWeight(.medium)
                            }
                            
                            // Encouraging message based on rating
                            Text(getEncouragingMessage(Int(skillEffectiveness)))
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.top, 4)
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                )
                
                Spacer(minLength: 100)
            }
            .padding()
        }
        .onAppear {
            // Load existing value if any
            skillEffectiveness = Double(diaryEntry.getSkillEffectiveness())
        }
    }
    
    func getEffectivenessColor(_ value: Int) -> Color {
        switch value {
        case 1...3:
            return .red
        case 4...5:
            return .orange
        case 6...7:
            return .yellow
        case 8...10:
            return .green
        default:
            return .blue
        }
    }
    
    func getEffectivenessDescription(_ value: Int) -> String {
        switch value {
        case 1:
            return "Not helpful"
        case 2...3:
            return "Minimally helpful"
        case 4...5:
            return "Somewhat helpful"
        case 6...7:
            return "Quite helpful"
        case 8...9:
            return "Very helpful"
        case 10:
            return "Extremely helpful"
        default:
            return ""
        }
    }
    
    func getEncouragingMessage(_ value: Int) -> String {
        switch value {
        case 1...3:
            return "That's okay - some days are harder than others. Even trying to use skills is progress."
        case 4...5:
            return "You're building your skills! Each time you practice, they become more effective."
        case 6...7:
            return "Great work! Your skills are helping you cope and manage difficult moments."
        case 8...10:
            return "Excellent! Your skills are serving you well. Keep up the amazing work!"
        default:
            return "Every effort to use your skills matters."
        }
    }
}

#Preview {
    SkillsStepView(diaryEntry: DiaryEntryViewModel(session: .manual))
}
