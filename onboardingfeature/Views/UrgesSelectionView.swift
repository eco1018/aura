

//
//
//  UrgesSelectionView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/29/25.
//

import SwiftUI

struct UrgesSelectionView: View {
    @State private var selectedUrges = Set<String>()
    @State private var customUrge1: String = ""
    @State private var customUrge2: String = ""

    let urges = [
        ("Substance Use", "The desire to use drugs or alcohol to cope with pain."),
        ("Disordered Eating", "The urge to restrict, binge, or purge food."),
        ("Shutting Down", "An urge to shut down emotionally and avoid interaction."),
        ("Breaking Things", "The urge to destroy things when frustrated."),
        ("Impulsive Sex", "A desire to engage in sexual behavior impulsively."),
        ("Impulsive Spending", "The urge to spend money recklessly."),
        ("Ending Relationships", "An urge to break up or end relationships impulsively."),
        ("Dropping Out", "The urge to quit or give up on commitments or responsibilities."),
        ("Other", "Something else you want to track — write it in.")
    ]
    
    var body: some View {
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
                VStack(spacing: 16) {
                    Text("Choose 2 Urges to Track")
                        .font(.system(size: 28, weight: .light, design: .default))
                        .foregroundColor(.primary.opacity(0.9))
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 60)
                
                // Glassmorphic urges list
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(urges, id: \.0) { urge in
                            // Individual urge card
                            HStack(spacing: 20) {
                                // Selection indicator
                                Button(action: {
                                    if urge.0 != "Other" {
                                        if selectedUrges.contains(urge.0) {
                                            selectedUrges.remove(urge.0)
                                        } else {
                                            if selectedUrges.count < 2 {
                                                selectedUrges.insert(urge.0)
                                            }
                                        }
                                    }
                                }) {
                                    Image(systemName: selectedUrges.contains(urge.0) ? "checkmark.circle.fill" : "circle")
                                        .font(.system(size: 22, weight: .light))
                                        .foregroundColor(selectedUrges.contains(urge.0) ? .primary.opacity(0.8) : .secondary.opacity(0.6))
                                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                                        .frame(width: 32, height: 32)
                                }
                                .disabled(urge.0 == "Other")
                                
                                // Content
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(urge.0)
                                        .font(.system(size: 17, weight: .medium))
                                        .foregroundColor(.primary.opacity(0.9))
                                    
                                    Text(urge.1)
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundColor(.secondary.opacity(0.7))
                                        .lineLimit(3)
                                        .fixedSize(horizontal: false, vertical: true)
                                    
                                    // Custom input for "Other"
                                    if urge.0 == "Other" {
                                        TextField("Describe your urge", text: $customUrge1)
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
                
                // Custom urge inputs section
                if selectedUrges.count >= 1 && !customUrge1.isEmpty {
                    VStack(spacing: 16) {
                        Text("Additional Custom Urge")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.secondary.opacity(0.8))
                        
                        TextField("Describe another urge", text: $customUrge2)
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
                    .padding(.horizontal, 24)
                }
                
                Spacer()
                
                // Elegant continue button
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

#Preview {
    UrgesSelectionView()
}
