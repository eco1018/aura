//
//
//
//  ActionsSelectionView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/29/25.
//

import SwiftUI

struct ActionsSelectionView: View {
    @ObservedObject var onboardingVM = OnboardingViewModel.shared
    @State private var customActionInput: String = ""

    let actions = [
        ("Substance Use", "Using alcohol or drugs to cope with pain or numb emotions."),
        ("Disordered Eating", "Restricting, bingeing, or purging food as a way to deal with emotions or regain control."),
        ("Lashing Out at Others", "Yelling, threatening, or saying things you don't mean when you're upset."),
        ("Withdrawing from People", "Isolating or cutting off others when you're hurting or overwhelmed."),
        ("Skipping Therapy or DBT Practice", "Avoiding appointments or not using skills when you meant to."),
        ("Risky Sexual Behavior", "Engaging in sexual behavior that feels impulsive, unsafe, or unaligned with your values."),
        ("Overspending or Impulsive Shopping", "Spending money in ways that feel compulsive or bring guilt."),
        ("Self-Neglect", "Going long periods without hygiene, eating, sleeping, or caring for your body."),
        ("Avoiding Responsibilities", "Ignoring school, work, or other obligations due to overwhelm or avoidance."),
        ("Breaking Rules or the Law", "Engaging in illegal, high-risk, or impulsive behaviors.")
    ]
    
    var totalSelected: Int {
        return onboardingVM.selectedActions.count + onboardingVM.customActions.count
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
                // Elegant header (matching MainView style)
                VStack(spacing: 16) {
                    Text("Choose 3 Actions to Track")
                        .font(.system(size: 28, weight: .light, design: .default))
                        .foregroundColor(.primary.opacity(0.9))
                        .multilineTextAlignment(.center)
                    
                    Text("Selected: \(totalSelected)/3")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.secondary.opacity(0.7))
                }
                .padding(.top, 60)
                .padding(.horizontal, 24)

                // Glassmorphic actions list
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(actions, id: \.0) { action in
                            ActionSelectionCard(
                                title: action.0,
                                description: action.1,
                                isSelected: onboardingVM.selectedActions.contains(action.0),
                                canSelect: totalSelected < 3 || onboardingVM.selectedActions.contains(action.0)
                            ) {
                                toggleActionSelection(action.0)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                }
                
                // Elegant custom action input
                if totalSelected < 3 {
                    VStack(spacing: 16) {
                        Text("Add Custom Action")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.secondary.opacity(0.8))
                        
                        HStack(spacing: 12) {
                            TextField("Describe your action", text: $customActionInput)
                                .font(.system(size: 15, weight: .regular))
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color(.systemBackground).opacity(0.8))
                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                        .shadow(color: .black.opacity(0.03), radius: 8, x: 0, y: 4)
                                )
                                .foregroundColor(.primary.opacity(0.8))
                            
                            Button(action: addCustomAction) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 24, weight: .light))
                                    .foregroundColor(.primary.opacity(0.8))
                                    .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                            }
                            .disabled(customActionInput.trimmingCharacters(in: .whitespaces).isEmpty)
                            .opacity(customActionInput.trimmingCharacters(in: .whitespaces).isEmpty ? 0.4 : 1.0)
                        }
                    }
                    .padding(.horizontal, 24)
                }
                
                // Custom actions display
                if !onboardingVM.customActions.isEmpty {
                    VStack(spacing: 12) {
                        Text("Your Custom Actions")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.secondary.opacity(0.8))
                        
                        ForEach(onboardingVM.customActions, id: \.self) { customAction in
                            HStack(spacing: 16) {
                                Text(customAction)
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundColor(.primary.opacity(0.8))
                                
                                Spacer()
                                
                                Button(action: {
                                    removeCustomAction(customAction)
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
                            .fill(Color.primary.opacity(0.9))
                            .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 6)
                            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                    )
                }
                .disabled(totalSelected == 0)
                .opacity(totalSelected == 0 ? 0.4 : 1.0)
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
                .animation(.easeInOut(duration: 0.2), value: totalSelected)
            }
        }
    }
    
    private func toggleActionSelection(_ action: String) {
        if onboardingVM.selectedActions.contains(action) {
            onboardingVM.selectedActions.removeAll { $0 == action }
        } else if totalSelected < 3 {
            onboardingVM.selectedActions.append(action)
        }
    }
    
    private func addCustomAction() {
        let trimmedInput = customActionInput.trimmingCharacters(in: .whitespaces)
        if !trimmedInput.isEmpty && totalSelected < 3 {
            onboardingVM.addCustomAction(trimmedInput)
            customActionInput = ""
        }
    }
    
    private func removeCustomAction(_ action: String) {
        onboardingVM.customActions.removeAll { $0 == action }
    }
}

struct ActionSelectionCard: View {
    let title: String
    let description: String
    let isSelected: Bool
    let canSelect: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 20) {
                // Selection indicator (matching UrgesSelectionView style)
                Button(action: onTap) {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 22, weight: .light))
                        .foregroundColor(isSelected ? .primary.opacity(0.8) : .secondary.opacity(0.6))
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                        .frame(width: 32, height: 32)
                }
                
                // Content (matching MainView card style)
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
    ActionsSelectionView()
}
