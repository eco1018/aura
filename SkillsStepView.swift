//
//
//  SkillsStepView.swift
//  aura
//
//  Created by Ella A. Sadduq on 5/22/25.
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
        NavigationView {
            ZStack {
                // Premium gradient background
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
                
                VStack(spacing: 60) {
                    // Elegant header
                    VStack(spacing: 20) {
                        Text("Skills Effectiveness")
                            .font(.system(size: 34, weight: .light, design: .default))
                            .foregroundColor(.primary.opacity(0.9))
                        
                        Text("How helpful were your skills today?")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.secondary.opacity(0.7))
                    }
                    .padding(.top, 80)
                    
                    Spacer()
                    
                    // Glassmorphic rating card
                    VStack(spacing: 32) {
                        // Current rating display
                        VStack(spacing: 8) {
                            Text("\(Int(skillEffectiveness))")
                                .font(.system(size: 72, weight: .ultraLight))
                                .foregroundColor(.primary.opacity(0.9))
                            
                            Text(getEffectivenessDescription(Int(skillEffectiveness)))
                                .font(.system(size: 17, weight: .regular))
                                .foregroundColor(.secondary.opacity(0.7))
                        }
                        
                        // Clean slider
                        VStack(spacing: 16) {
                            Slider(value: $skillEffectiveness, in: 1...10, step: 1)
                                .tint(.primary.opacity(0.8))
                                .onChange(of: skillEffectiveness) { _, newValue in
                                    diaryEntry.updateSkillEffectiveness(Int(newValue))
                                }
                            
                            HStack {
                                Text("1")
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundColor(.secondary.opacity(0.6))
                                
                                Spacer()
                                
                                Text("10")
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundColor(.secondary.opacity(0.6))
                            }
                        }
                        
                        // Encouraging message
                        Text(getEncouragingMessage(Int(skillEffectiveness)))
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.secondary.opacity(0.6))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                    .padding(40)
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
                    .padding(.horizontal, 28)
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            // Load existing value if any
            skillEffectiveness = Double(diaryEntry.getSkillEffectiveness())
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
