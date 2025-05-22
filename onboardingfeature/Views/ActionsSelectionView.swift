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
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 8) {
                Text("Choose 3 Actions to Track")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                
                Text("Selected: \(totalSelected)/3")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)

            // Actions List
            ScrollView {
                LazyVStack(spacing: 12) {
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
                .padding(.horizontal)
            }
            
            // Custom Action Input
            if totalSelected < 3 {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Add Custom Action")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        TextField("Describe your action", text: $customActionInput)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button(action: addCustomAction) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.accentColor)
                        }
                        .disabled(customActionInput.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                }
                .padding(.horizontal)
            }
            
            // Custom Actions Display
            if !onboardingVM.customActions.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Your Custom Actions:")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    ForEach(onboardingVM.customActions, id: \.self) { customAction in
                        HStack {
                            Text(customAction)
                                .font(.body)
                            
                            Spacer()
                            
                            Button(action: {
                                removeCustomAction(customAction)
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.horizontal)
            }

            Spacer()

            Button(action: {
                onboardingVM.goToNextStep()
            }) {
                Text("Next")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(totalSelected > 0 ? Color.accentColor : Color.gray)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }
            .disabled(totalSelected == 0)
        }
        .padding(.vertical)
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
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .accentColor : (canSelect ? .gray : .gray.opacity(0.3)))
                    .font(.title3)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.accentColor.opacity(0.1) : Color(.systemGray6))
                    .stroke(isSelected ? Color.accentColor : Color.clear, lineWidth: 1)
            )
        }
        .disabled(!canSelect && !isSelected)
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ActionsSelectionView()
}
