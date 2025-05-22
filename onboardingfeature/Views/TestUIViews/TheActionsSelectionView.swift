//
// TheActionsSelectionView.swift
// Aura_iOS

import SwiftUI

struct TheActionsSelectionView: View {
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()

            VStack(spacing: 24) {
                // 🌸 Floating soft blobs and Aura title
                ZStack {
                    FloatingBlobs()

                    Text("Aura")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                        .padding()
                        .background(
                            Circle()
                                .fill(Color("Background"))
                                .shadow(color: .white.opacity(0.7), radius: 8, x: -6, y: -6)
                                .shadow(color: .black.opacity(0.1), radius: 6, y: 6)
                        )
                }
                .frame(height: 200)
                .padding(.top)

                Text("Choose 3 Actions to Track")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(sampleActions, id: \.title) { action in
                            ActionCard(action: action)
                        }
                    }
                    .padding(.horizontal)
                }

                Spacer()

                NeoButton(title: "Next")
                    .padding(.horizontal)
                    .padding(.bottom)
            }
        }
    }
}

// MARK: - Action Card

struct ActionCard: View {
    var action: ActionChoice

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(action.title)
                    .font(.headline)
                    .foregroundColor(.primary)

                Spacer()

                Image(systemName: "circle")
                    .foregroundColor(.gray)
            }

            Text(action.description)
                .font(.footnote)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color("Background"))
                .shadow(color: .white.opacity(0.8), radius: 6, x: -6, y: -6)
                .shadow(color: .black.opacity(0.1), radius: 6, x: 6, y: 6)
        )
    }
}

// MARK: - Floating Blobs

struct FloatingBlobs: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.yellow.opacity(0.4), Color.orange.opacity(0.3)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .blur(radius: 60)
                .offset(x: -50, y: -30)

            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.purple.opacity(0.3), Color.blue.opacity(0.2)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .blur(radius: 60)
                .offset(x: 50, y: 30)
        }
    }
}

// MARK: - Neo Button

struct NeoButton: View {
    var title: String

    var body: some View {
        Text(title)
            .fontWeight(.semibold)
            .foregroundColor(.primary)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color("Background"))
                    .shadow(color: .white.opacity(0.8), radius: 6, x: -6, y: -6)
                    .shadow(color: .black.opacity(0.15), radius: 6, x: 6, y: 6)
            )
    }
}

// MARK: - Action Choices

struct ActionChoice {
    let title: String
    let description: String
}

let sampleActions: [ActionChoice] = [
    ActionChoice(title: "Substance Use", description: "Using alcohol or drugs to cope with pain or numb emotions."),
    ActionChoice(title: "Disordered Eating", description: "Restricting, bingeing, or purging food as a way to deal with emotions or regain control."),
    ActionChoice(title: "Lashing Out at Others", description: "Yelling, threatening, or saying things you don’t mean when you’re upset."),
    ActionChoice(title: "Withdrawing from People", description: "Isolating or cutting off others when you’re hurting or overwhelmed."),
    ActionChoice(title: "Skipping Therapy or DBT Practice", description: "Avoiding appointments or not using skills when you meant to."),
    ActionChoice(title: "Risky Sexual Behavior", description: "Engaging in sexual behavior that feels impulsive, unsafe, or unaligned with your values."),
    ActionChoice(title: "Overspending or Impulsive Shopping", description: "Spending money in ways that feel compulsive or bring guilt."),
    ActionChoice(title: "Self-Neglect", description: "Going long periods without hygiene, eating, sleeping, or caring for your body."),
    ActionChoice(title: "Avoiding Responsibilities", description: "Ignoring school, work, or other obligations due to overwhelm or avoidance."),
    ActionChoice(title: "Breaking Rules or the Law", description: "Engaging in illegal, high-risk, or impulsive behaviors."),
    ActionChoice(title: "Other", description: "Something else important to you — write it in.")
]

// MARK: - Preview

#Preview {
    TheActionsSelectionView()
}
