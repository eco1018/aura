//
//  GoalsSelectionView.swift
//  aura
//
//
//
//  GoalsSelectionView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/29/25.
//

import SwiftUI

struct GoalsSelectionView: View {
    @ObservedObject var onboardingVM = OnboardingViewModel.shared
    @State private var customGoalInput: String = ""

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
        ("Align with Values", "Make choices that align with your core values.")
    ]
    
    var totalSelected: Int {
        return onboardingVM.selectedGoals.count + onboardingVM.customGoals.count
    }
    
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
                    
                    Text("Selected: \(totalSelected)/3")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.secondary.opacity(0.7))
                }
                .padding(.top, 60)
                .padding(.horizontal, 24)

                // Glassmorphic goals list
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(goals, id: \.0) { goal in
                            GoalSelectionCard(
                                title: goal.0,
                                description: goal.1,
                                isSelected: onboardingVM.selectedGoals.contains(goal.0),
                                canSelect: totalSelected < 3 || onboardingVM.selectedGoals.contains(goal.0)
                            ) {
                                toggleGoalSelection(goal.0)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                }
                
                // Custom goal input
                if totalSelected < 3 {
                    VStack(spacing: 16) {
                        Text("Add Custom Goal")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.secondary.opacity(0.8))
                        
                        HStack(spacing: 12) {
                            TextField("Describe your goal", text: $customGoalInput)
                                .font(.system(size: 15, weight: .regular))
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color(.systemBackground).opacity(0.8))
                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                        .shadow(color: .black.opacity(0.03), radius: 8, x: 0, y: 4)
                                )
                                .foregroundColor(.primary.opacity(0.8))
                            
                            Button(action: addCustomGoal) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 24, weight: .light))
                                    .foregroundColor(.primary.opacity(0.8))
                                    .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                            }
                            .disabled(customGoalInput.trimmingCharacters(in: .whitespaces).isEmpty)
                            .opacity(customGoalInput.trimmingCharacters(in: .whitespaces).isEmpty ? 0.4 : 1.0)
                        }
                    }
                    .padding(.horizontal, 24)
                }
                
                // Custom goals display
                if !onboardingVM.customGoals.isEmpty {
                    VStack(spacing: 12) {
                        Text("Your Custom Goals")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.secondary.opacity(0.8))
                        
                        ForEach(onboardingVM.customGoals, id: \.self) { customGoal in
                            HStack(spacing: 16) {
                                Text(customGoal)
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundColor(.primary.opacity(0.8))
                                
                                Spacer()
                                
                                Button(action: {
                                    removeCustomGoal(customGoal)
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.system(size: 18, weight: .light))
                                        .foregroundColor(.red.opacity(0.7))
                                }
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(.systemBackground).opacity(0.6))
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    .shadow(color: .black.opacity(0.02), radius: 4, x: 0, y: 2)
                            )
                        }
                    }
                    .padding(.horizontal, 24)
                }

                Spacer()

                // Standard next button (matching other onboarding views)
                Button(action: {
                    print("📝 Goals selected: \(onboardingVM.selectedGoals)")
                    print("📝 Custom goals: \(onboardingVM.customGoals)")
                    onboardingVM.goToNextStep()
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
                            .fill(totalSelected > 0 ? Color.primary.opacity(0.9) : Color.secondary.opacity(0.4))
                            .shadow(color: .black.opacity(totalSelected > 0 ? 0.15 : 0), radius: 12, x: 0, y: 6)
                            .shadow(color: .black.opacity(totalSelected > 0 ? 0.05 : 0), radius: 2, x: 0, y: 1)
                    )
                }
                .disabled(totalSelected == 0)
                .animation(.easeInOut(duration: 0.2), value: totalSelected)
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
    }
    
    private func toggleGoalSelection(_ goal: String) {
        if onboardingVM.selectedGoals.contains(goal) {
            onboardingVM.selectedGoals.removeAll { $0 == goal }
        } else if totalSelected < 3 {
            onboardingVM.selectedGoals.append(goal)
        }
    }
    
    private func addCustomGoal() {
        let trimmedInput = customGoalInput.trimmingCharacters(in: .whitespaces)
        if !trimmedInput.isEmpty && totalSelected < 3 {
            onboardingVM.addCustomGoal(trimmedInput)
            customGoalInput = ""
        }
    }
    
    private func removeCustomGoal(_ goal: String) {
        onboardingVM.customGoals.removeAll { $0 == goal }
    }
}

struct GoalSelectionCard: View {
    let title: String
    let description: String
    let isSelected: Bool
    let canSelect: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 20) {
                // Selection indicator
                Button(action: onTap) {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 22, weight: .light))
                        .foregroundColor(isSelected ? .primary.opacity(0.8) : .secondary.opacity(0.6))
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                        .frame(width: 32, height: 32)
                }
                
                // Content
                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.primary.opacity(0.9))
                    
                    Text(description)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.secondary.opacity(0.7))
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)
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
        .disabled(!canSelect && !isSelected)
        .opacity(!canSelect && !isSelected ? 0.5 : 1.0)
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

#Preview {
    GoalsSelectionView()
}
