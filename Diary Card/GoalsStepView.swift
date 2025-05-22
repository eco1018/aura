//
//  GoalsStepView.swift
//  aura
//
//  Created by Ella A. Sadduq on 5/22/25.
//


//
//  GoalsStepView.swift
//  aura
//
//  Created by Ella A. Sadduq on 5/22/25.
//

import SwiftUI

struct GoalsStepView: View {
    @ObservedObject var diaryEntry: DiaryEntryViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header section
                VStack(spacing: 8) {
                    Image(systemName: DiaryStep.goals.systemImage)
                        .font(.largeTitle)
                        .foregroundColor(.green)
                    
                    Text(DiaryStep.goals.title)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(DiaryStep.goals.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top)
                
                // Instruction
                Text("Check off the goals you accomplished today:")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Goal cards
                VStack(spacing: 12) {
                    ForEach(diaryEntry.getAllGoals(), id: \.key) { goal in
                        GoalCard(
                            title: goal.title,
                            isCompleted: goal.completed,
                            onToggle: { completed in
                                diaryEntry.updateGoalCompletion(goal.key, completed: completed)
                            }
                        )
                    }
                }
                
                // If no goals, show encouraging message
                if diaryEntry.getAllGoals().isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "star.circle")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                        
                        Text("No goals set yet")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text("You can add personal goals during onboarding to track your daily progress here.")
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
    }
}

struct GoalCard: View {
    let title: String
    let isCompleted: Bool
    let onToggle: (Bool) -> Void
    
    var body: some View {
        Button(action: {
            onToggle(!isCompleted)
        }) {
            HStack(spacing: 16) {
                // Checkmark
                Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(isCompleted ? .green : .gray)
                
                // Goal text
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                        .strikethrough(isCompleted)
                    
                    Text(getMotivationalText(for: title))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Status indicator
                if isCompleted {
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundColor(.yellow)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isCompleted ? Color.green.opacity(0.1) : Color(.systemGray6))
                    .stroke(isCompleted ? Color.green.opacity(0.3) : Color.clear, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    func getMotivationalText(for goal: String) -> String {
        switch goal.lowercased() {
        case let g where g.contains("skill"):
            return "Every skill you use builds your emotional toolkit"
        case let g where g.contains("reach"):
            return "Connection is courage in action"
        case let g where g.contains("routine"):
            return "Small consistent actions create big changes"
        case let g where g.contains("nourish"):
            return "Your body deserves care and attention"
        case let g where g.contains("move"):
            return "Movement is medicine for both body and mind"
        case let g where g.contains("bed"):
            return "Getting up is often the hardest and bravest step"
        case let g where g.contains("compassion"):
            return "Treat yourself with the kindness you'd show a friend"
        case let g where g.contains("help"):
            return "Asking for help is a sign of wisdom, not weakness"
        case let g where g.contains("values"):
            return "Living by your values brings authentic fulfillment"
        case let g where g.contains("exercise") || g.contains("workout"):
            return "Physical activity strengthens both body and mind"
        case let g where g.contains("meditat"):
            return "Even a few minutes of mindfulness can shift your day"
        case let g where g.contains("journal"):
            return "Writing helps process emotions and gain clarity"
        case let g where g.contains("sleep"):
            return "Quality rest is the foundation of mental wellness"
        case let g where g.contains("eat"):
            return "Nourishing your body supports emotional balance"
        case let g where g.contains("friend") || g.contains("social"):
            return "Meaningful connections enrich our lives"
        case let g where g.contains("clean") || g.contains("organize"):
            return "A tidy environment can bring mental clarity"
        case let g where g.contains("read"):
            return "Learning and growth happen one page at a time"
        default:
            return "Every step forward matters, no matter how small"
        }
    }
}

#Preview {
    GoalsStepView(diaryEntry: DiaryEntryViewModel(session: .manual))
}