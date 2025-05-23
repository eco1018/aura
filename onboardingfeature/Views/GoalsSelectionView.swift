//
//  GoalsSelectionView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/29/25.
//

//
//  GoalsSelectionView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/29/25.
//

import SwiftUI

struct GoalsSelectionView: View {
    @State private var selectedGoals = Set<String>()
    @State private var customGoal1: String = ""
    @State private var customGoal2: String = ""
    @State private var customGoal3: String = ""

    let goals = [
        ("Use DBT Skill", "Practice using a DBT skill when feeling overwhelmed."),
        ("Reach Out", "Reach out to someone for support when needed."),
        ("Follow Routine", "Stick to a daily routine to provide structure."),
        ("Nourish", "Make sure you're eating and taking care of your physical health."),
        ("Move Body", "Engage in physical activity to take care of your body."),
        ("Get Out of Bed", "Commit to getting out of bed, even on hard days."),
        ("Self-Compassion", "Practice kindness towards yourself, especially in difficult moments."),
        ("Ask for Help", "Be proactive in asking for support when you need it."),
        ("Do For Me", "Set aside time to do something that's just for you."),
        ("Align with Values", "Make choices that align with your core values."),
        ("Other", "Something else you want to track — write it in.")
    ]
    
    var body: some View {
        ZStack {
            // Premium gradient background (matching MainView)
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
            
            VStack(spacing: 40) {
                // Elegant header (matching design system)
                VStack(spacing: 16) {
                    Text("Choose 3 Goals to Track")
                        .font(.system(size: 28, weight: .light, design: .default))
                        .foregroundColor(.primary.opacity(0.9))
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 60)
                .padding(.horizontal, 24)

                // Glassmorphic goals list
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(goals, id: \.0) { goal in
                            // Individual goal card
                            HStack(spacing: 20) {
                                // Selection indicator
                                Button(action: {
                                    if goal.0 != "Other" {
                                        if selectedGoals.contains(goal.0) {
                                            selectedGoals.remove(goal.0)
                                        } else {
                                            if selectedGoals.count < 3 {
                                                selectedGoals.insert(goal.0)
                                            }
                                        }
                                    }
                                }) {
                                    Image(systemName: selectedGoals.contains(goal.0) ? "checkmark.circle.fill" : "circle")
                                        .font(.system(size: 22, weight: .light))
                                        .foregroundColor(selectedGoals.contains(goal.0) ? .primary.opacity(0.8) : .secondary.opacity(0.6))
                                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                                        .frame(width: 32, height: 32)
                                }
                                .disabled(goal.0 == "Other")
                                
                                // Content
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(goal.0)
                                        .font(.system(size: 17, weight: .medium))
                                        .foregroundColor(.primary.opacity(0.9))
                                    
                                    Text(goal.1)
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundColor(.secondary.opacity(0.7))
                                        .lineLimit(3)
                                        .fixedSize(horizontal: false, vertical: true)
                                    
                                    // Custom input for "Other"
                                    if goal.0 == "Other" {
                                        TextField("Describe your goal", text: $customGoal1)
                                            .font(.system(size: 15, weight: .regular))
                                            .padding(12)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(Color(.systemBackground).opacity(0.6))
                                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                            )
                                            .foregroundColor(.primary.opacity(0.8))
                                    }
                                }
                                
                                Spacer()
                            }
                            .padding(24)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color(.systemBackground).opacity(0.8))
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                                    .shadow(color: .black.opacity(0.04), radius: 16, x: 0, y: 6)
                                    .shadow(color: .black.opacity(0.02), radius: 1, x: 0, y: 1)
                            )
                        }
                    }
                    .padding(.horizontal, 24)
                }
                
                // Custom goal inputs section
                VStack(spacing: 16) {
                    if selectedGoals.count >= 1 && !customGoal1.isEmpty {
                        CustomGoalInput(
                            title: "Custom Goal 1",
                            text: $customGoal1
                        )
                    }
                    
                    if selectedGoals.count >= 2 && !customGoal2.isEmpty {
                        CustomGoalInput(
                            title: "Custom Goal 2",
                            text: $customGoal2
                        )
                    }
                    
                    if selectedGoals.count >= 3 && !customGoal3.isEmpty {
                        CustomGoalInput(
                            title: "Custom Goal 3",
                            text: $customGoal3
                        )
                    }
                }
                .padding(.horizontal, 24)

                Spacer()

                // Standard next button (matching other onboarding views)
                Button(action: {
                    OnboardingViewModel.shared.goToNextStep()
                }) {
                    HStack(spacing: 12) {
                        Text("Next")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.primary.opacity(0.9))
                            .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 6)
                            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                    )
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
    }
}

struct CustomGoalInput: View {
    let title: String
    @Binding var text: String
    
    var body: some View {
        VStack(spacing: 12) {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.secondary.opacity(0.8))
            
            TextField("Describe your goal", text: $text)
                .font(.system(size: 15, weight: .regular))
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemBackground).opacity(0.8))
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        .shadow(color: .black.opacity(0.03), radius: 8, x: 0, y: 4)
                )
                .foregroundColor(.primary.opacity(0.8))
        }
    }
}

#Preview {
    GoalsSelectionView()
}
