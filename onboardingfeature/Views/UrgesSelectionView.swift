

//
//
//
//  UrgesSelectionView.swift
//  aura
//
//  UrgesSelectionView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/29/25.
//

import SwiftUI

struct UrgesSelectionView: View {
    @ObservedObject var onboardingVM = OnboardingViewModel.shared
    @State private var customUrgeInput: String = ""

    let urges = [
        ("Substance Use", "The desire to use drugs or alcohol to cope with pain."),
        ("Disordered Eating", "The urge to restrict, binge, or purge food."),
        ("Shutting Down", "An urge to shut down emotionally and avoid interaction."),
        ("Breaking Things", "The urge to destroy things when frustrated."),
        ("Impulsive Sex", "A desire to engage in sexual behavior impulsively."),
        ("Impulsive Spending", "The urge to spend money recklessly."),
        ("Ending Relationships", "An urge to break up or end relationships impulsively."),
        ("Dropping Out", "The urge to quit or give up on commitments or responsibilities.")
    ]
    
    var totalSelected: Int {
        return onboardingVM.selectedUrges.count + onboardingVM.customUrges.count
    }
    
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
                    
                    Text("Selected: \(totalSelected)/2")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.secondary.opacity(0.7))
                }
                .padding(.top, 60)
                
                // Glassmorphic urges list
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(urges, id: \.0) { urge in
                            UrgeSelectionCard(
                                title: urge.0,
                                description: urge.1,
                                isSelected: onboardingVM.selectedUrges.contains(urge.0),
                                canSelect: totalSelected < 2 || onboardingVM.selectedUrges.contains(urge.0)
                            ) {
                                toggleUrgeSelection(urge.0)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                }
                
                // Custom urge input
                if totalSelected < 2 {
                    VStack(spacing: 16) {
                        Text("Add Custom Urge")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.secondary.opacity(0.8))
                        
                        HStack(spacing: 12) {
                            TextField("Describe your urge", text: $customUrgeInput)
                                .font(.system(size: 15, weight: .regular))
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color(.systemBackground).opacity(0.8))
                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                        .shadow(color: .black.opacity(0.03), radius: 8, x: 0, y: 4)
                                )
                                .foregroundColor(.primary.opacity(0.8))
                            
                            Button(action: addCustomUrge) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 24, weight: .light))
                                    .foregroundColor(.primary.opacity(0.8))
                                    .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                            }
                            .disabled(customUrgeInput.trimmingCharacters(in: .whitespaces).isEmpty)
                            .opacity(customUrgeInput.trimmingCharacters(in: .whitespaces).isEmpty ? 0.4 : 1.0)
                        }
                    }
                    .padding(.horizontal, 24)
                }
                
                // Custom urges display
                if !onboardingVM.customUrges.isEmpty {
                    VStack(spacing: 12) {
                        Text("Your Custom Urges")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.secondary.opacity(0.8))
                        
                        ForEach(onboardingVM.customUrges, id: \.self) { customUrge in
                            HStack(spacing: 16) {
                                Text(customUrge)
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundColor(.primary.opacity(0.8))
                                
                                Spacer()
                                
                                Button(action: {
                                    removeCustomUrge(customUrge)
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
                
                // Elegant continue button
                Button(action: {
                    print("📝 Urges selected: \(onboardingVM.selectedUrges)")
                    print("📝 Custom urges: \(onboardingVM.customUrges)")
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
    
    private func toggleUrgeSelection(_ urge: String) {
        if onboardingVM.selectedUrges.contains(urge) {
            onboardingVM.selectedUrges.removeAll { $0 == urge }
        } else if totalSelected < 2 {
            onboardingVM.selectedUrges.append(urge)
        }
    }
    
    private func addCustomUrge() {
        let trimmedInput = customUrgeInput.trimmingCharacters(in: .whitespaces)
        if !trimmedInput.isEmpty && totalSelected < 2 {
            onboardingVM.addCustomUrge(trimmedInput)
            customUrgeInput = ""
        }
    }
    
    private func removeCustomUrge(_ urge: String) {
        onboardingVM.customUrges.removeAll { $0 == urge }
    }
}

struct UrgeSelectionCard: View {
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
    UrgesSelectionView()
}
