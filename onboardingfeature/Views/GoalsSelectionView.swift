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
        ("Nourish", "Make sure you’re eating and taking care of your physical health."),
        ("Move Body", "Engage in physical activity to take care of your body."),
        ("Get Out of Bed", "Commit to getting out of bed, even on hard days."),
        ("Self-Compassion", "Practice kindness towards yourself, especially in difficult moments."),
        ("Ask for Help", "Be proactive in asking for support when you need it."),
        ("Do For Me", "Set aside time to do something that’s just for you."),
        ("Align with Values", "Make choices that align with your core values."),
        ("Other", "Something else you want to track — write it in.")
    ]
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            // MARK: - Title
            Text("Choose 3 Goals to Track")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            // MARK: - Goals List
            List(goals, id: \.0) { goal in
                HStack {
                    Text(goal.0)
                        .font(.body)
                        .fontWeight(.semibold)
                        .padding(.trailing, 8)
                    Spacer()
                    Text(goal.1)
                        .font(.body)
                        .foregroundColor(.gray)
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)

                    if goal.0 == "Other" {
                        TextField("Describe your goal", text: $customGoal1)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.trailing)
                            .padding(.vertical, 8) // Add more vertical space for custom input
                    } else {
                        Button(action: {
                            if selectedGoals.contains(goal.0) {
                                selectedGoals.remove(goal.0)
                            } else {
                                if selectedGoals.count < 3 {
                                    selectedGoals.insert(goal.0)
                                }
                            }
                        }) {
                            Image(systemName: selectedGoals.contains(goal.0) ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(selectedGoals.contains(goal.0) ? .accentColor : .gray)
                        }
                        .padding(.vertical, 8) // Added space around the selection button
                    }
                }
                .padding(.vertical, 12) // Increased space between each list item
            }
            .frame(height: 350) // Limit list height

            // MARK: - Custom Goal Input Section (if needed)
            if selectedGoals.count == 1 {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Custom Goal 1")
                        .font(.headline)
                        .foregroundColor(.gray)
                    TextField("Describe your goal", text: $customGoal1)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                }
                .padding(.vertical, 12)
            }
            if selectedGoals.count == 2 {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Custom Goal 2")
                        .font(.headline)
                        .foregroundColor(.gray)
                    TextField("Describe your goal", text: $customGoal2)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                }
                .padding(.vertical, 12)
            }
            if selectedGoals.count == 3 {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Custom Goal 3")
                        .font(.headline)
                        .foregroundColor(.gray)
                    TextField("Describe your goal", text: $customGoal3)
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
                .background(selectedGoals.count == 3 ? Color.accentColor : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding(.horizontal)
                .disabled(selectedGoals.count != 3)
        }
        .padding(.horizontal)
    }
}

#Preview {
    GoalsSelectionView()
}
