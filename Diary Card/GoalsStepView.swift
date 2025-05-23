//
//  GoalsStepView.swift
//  aura
//
//  Created by Ella A. Sadduq on 5/22/25.
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
                
                VStack(spacing: 40) {
                    // Elegant header
                    VStack(spacing: 20) {
                        Text("Today's Goals")
                            .font(.system(size: 34, weight: .light, design: .default))
                            .foregroundColor(.primary.opacity(0.9))
                        
                        Text("Track your daily progress")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.secondary.opacity(0.7))
                    }
                    .padding(.top, 80)
                    
                    // Goals content
                    ScrollView {
                        VStack(spacing: 24) {
                            // Goal cards with glassmorphic design
                            ForEach(diaryEntry.getAllGoals(), id: \.key) { goal in
                                GlassmorphicGoalCard(
                                    title: goal.title,
                                    isCompleted: goal.completed,
                                    onToggle: { completed in
                                        diaryEntry.updateGoalCompletion(goal.key, completed: completed)
                                    }
                                )
                            }
                            
                            // If no goals, show elegant empty state
                            if diaryEntry.getAllGoals().isEmpty {
                                GlassmorphicEmptyState()
                            }
                        }
                        .padding(.horizontal, 28)
                        .padding(.bottom, 100)
                    }
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct GlassmorphicGoalCard: View {
    let title: String
    let isCompleted: Bool
    let onToggle: (Bool) -> Void
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.4)) {
                onToggle(!isCompleted)
            }
        }) {
            HStack(spacing: 20) {
                // Subtle checkmark
                ZStack {
                    Circle()
                        .fill(isCompleted ? Color.primary.opacity(0.8) : Color(.systemGray5))
                        .frame(width: 28, height: 28)
                        .shadow(color: .primary.opacity(0.1), radius: 2, x: 1, y: 1)
                        .shadow(color: .white.opacity(0.8), radius: 1, x: -0.5, y: -0.5)
                    
                    if isCompleted {
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .animation(.spring(response: 0.4), value: isCompleted)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .font(.system(size: 19, weight: .medium))
                        .foregroundColor(.primary.opacity(0.9))
                    
                    Text(getMotivationalText(for: title))
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.secondary.opacity(0.6))
                        .lineLimit(2)
                }
                
                Spacer()
            }
            .padding(28)
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

struct GlassmorphicEmptyState: View {
    var body: some View {
        VStack(spacing: 20) {
            // Elegant 3D icon
            Image(systemName: "star.circle")
                .font(.system(size: 48, weight: .light))
                .foregroundColor(.primary.opacity(0.8))
                .shadow(color: .primary.opacity(0.1), radius: 2, x: 1, y: 1)
                .shadow(color: .white.opacity(0.8), radius: 1, x: -0.5, y: -0.5)
            
            VStack(spacing: 12) {
                Text("No goals set yet")
                    .font(.system(size: 19, weight: .medium))
                    .foregroundColor(.primary.opacity(0.9))
                
                Text("You can add personal goals during onboarding to track your daily progress here.")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.secondary.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
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
    }
}

#Preview {
    GoalsStepView(diaryEntry: DiaryEntryViewModel(session: .manual))
}
