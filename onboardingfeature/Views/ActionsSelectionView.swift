//
//  ActionsSelectionView.swift



//  ActionsSelectionView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/29/25.
//

import SwiftUI

struct ActionsSelectionView: View {
    @State private var selectedActions = Set<String>()
    @State private var customAction1: String = ""
    @State private var customAction2: String = ""
    @State private var customAction3: String = ""

    let actions = [
        ("Substance Use", "Using alcohol or drugs to cope with pain or numb emotions."),
        ("Disordered Eating", "Restricting, bingeing, or purging food as a way to deal with emotions or regain control."),
        ("Lashing Out at Others", "Yelling, threatening, or saying things you don’t mean when you’re upset."),
        ("Withdrawing from People", "Isolating or cutting off others when you’re hurting or overwhelmed."),
        ("Skipping Therapy or DBT Practice", "Avoiding appointments or not using skills when you meant to."),
        ("Risky Sexual Behavior", "Engaging in sexual behavior that feels impulsive, unsafe, or unaligned with your values."),
        ("Overspending or Impulsive Shopping", "Spending money in ways that feel compulsive or bring guilt."),
        ("Self-Neglect", "Going long periods without hygiene, eating, sleeping, or caring for your body."),
        ("Avoiding Responsibilities", "Ignoring school, work, or other obligations due to overwhelm or avoidance."),
        ("Breaking Rules or the Law", "Engaging in illegal, high-risk, or impulsive behaviors."),
        ("Other", "Something else important to you — write it in.")
    ]
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            // MARK: - Title
            Text("Choose 3 Actions to Track")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            // MARK: - Actions List
            List(actions, id: \.0) { action in
                HStack {
                    Text(action.0)
                        .font(.body)
                        .fontWeight(.semibold)
                        .padding(.trailing, 8)
                    Spacer()
                    Text(action.1)
                        .font(.body)
                        .foregroundColor(.gray)
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.vertical, 4) // Space between description and selection button

                    if action.0 == "Other" {
                        TextField("Describe action", text: $customAction1)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.trailing)
                            .padding(.vertical, 8) // Add more vertical space for custom input
                    } else {
                        Button(action: {
                            if selectedActions.contains(action.0) {
                                selectedActions.remove(action.0)
                            } else {
                                if selectedActions.count < 3 {
                                    selectedActions.insert(action.0)
                                }
                            }
                        }) {
                            Image(systemName: selectedActions.contains(action.0) ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(selectedActions.contains(action.0) ? .accentColor : .gray)
                        }
                        .padding(.vertical, 8) // Added space around the selection button
                    }
                }
                .padding(.vertical, 12) // Increased space between each list item
            }
            .frame(height: 350) // Slightly increased frame height for better spacing
            
            // MARK: - Custom Action Input Section (if needed)
            if selectedActions.count == 1 {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Custom Action 1")
                        .font(.headline)
                        .foregroundColor(.gray)
                    TextField("Describe action", text: $customAction1)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                }
                .padding(.vertical, 12)
            }
            if selectedActions.count == 2 {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Custom Action 2")
                        .font(.headline)
                        .foregroundColor(.gray)
                    TextField("Describe action", text: $customAction2)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                }
                .padding(.vertical, 12)
            }
            if selectedActions.count == 3 {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Custom Action 3")
                        .font(.headline)
                        .foregroundColor(.gray)
                    TextField("Describe action", text: $customAction3)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                }
                .padding(.vertical, 12)
            }

            Spacer()

            // MARK: - Continue Button (UI only)
            Text("Continue")
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(selectedActions.count == 3 ? Color.accentColor : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding(.horizontal)
                .disabled(selectedActions.count != 3)
        }
        .padding(.horizontal)
    }
}

#Preview {
    ActionsSelectionView()
}
