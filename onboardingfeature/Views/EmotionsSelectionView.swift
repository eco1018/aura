//
//  EmotionsSelectionView.swift
//  aura
//
//  Created by Ella A. Sadduq on 6/29/25.
//


//
//  EmotionsSelectionView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/29/25.
//

import SwiftUI

struct EmotionsSelectionView: View {
    @ObservedObject var onboardingVM = OnboardingViewModel.shared
    
    let emotions = [
        "Happy", "Sad", "Angry", "Anxious", "Calm", "Frustrated",
        "Excited", "Scared", "Grateful", "Lonely", "Proud", "Ashamed",
        "Hopeful", "Overwhelmed", "Content", "Irritated", "Peaceful", "Confused"
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
                    Text("Choose 6 Emotions to Track")
                        .font(.system(size: 28, weight: .light, design: .default))
                        .foregroundColor(.primary.opacity(0.9))
                        .multilineTextAlignment(.center)
                    
                    Text("Selected: \(onboardingVM.selectedEmotions.count)/6")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.secondary.opacity(0.7))
                    
                    Text("These emotions will appear in your daily diary card")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.secondary.opacity(0.6))
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 60)
                .padding(.horizontal, 24)
                
                // Emotions grid
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 12) {
                        ForEach(emotions, id: \.self) { emotion in
                            Button(action: {
                                toggleEmotionSelection(emotion)
                            }) {
                                Text(emotion)
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(onboardingVM.selectedEmotions.contains(emotion) ? .white : .primary.opacity(0.8))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(onboardingVM.selectedEmotions.contains(emotion) ? 
                                                  Color.primary.opacity(0.8) : 
                                                  Color(.systemBackground).opacity(0.8))
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                            )
                                            .shadow(color: .black.opacity(0.03), radius: 6, x: 0, y: 3)
                                    )
                            }
                            .buttonStyle(PlainButtonStyle())
                            .disabled(onboardingVM.selectedEmotions.count >= 6 && !onboardingVM.selectedEmotions.contains(emotion))
                            .opacity((onboardingVM.selectedEmotions.count >= 6 && !onboardingVM.selectedEmotions.contains(emotion)) ? 0.5 : 1.0)
                            .animation(.easeInOut(duration: 0.2), value: onboardingVM.selectedEmotions.contains(emotion))
                        }
                    }
                    .padding(.horizontal, 24)
                }
                
                Spacer()
                
                // Instructions and Continue button
                VStack(spacing: 20) {
                    if onboardingVM.selectedEmotions.count < 6 {
                        Text("Select \(6 - onboardingVM.selectedEmotions.count) more emotion\(6 - onboardingVM.selectedEmotions.count == 1 ? "" : "s")")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.secondary.opacity(0.7))
                    }
                    
                    // Continue button
                    Button(action: {
                        print("📝 Emotions selected: \(onboardingVM.selectedEmotions)")
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
                                .fill(onboardingVM.selectedEmotions.count >= 3 ? Color.primary.opacity(0.9) : Color.secondary.opacity(0.4))
                                .shadow(color: .black.opacity(onboardingVM.selectedEmotions.count >= 3 ? 0.15 : 0), radius: 12, x: 0, y: 6)
                                .shadow(color: .black.opacity(onboardingVM.selectedEmotions.count >= 3 ? 0.05 : 0), radius: 2, x: 0, y: 1)
                        )
                    }
                    .disabled(onboardingVM.selectedEmotions.count < 3)
                    .animation(.easeInOut(duration: 0.2), value: onboardingVM.selectedEmotions.count)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
    }
    
    private func toggleEmotionSelection(_ emotion: String) {
        if onboardingVM.selectedEmotions.contains(emotion) {
            onboardingVM.selectedEmotions.removeAll { $0 == emotion }
        } else if onboardingVM.selectedEmotions.count < 6 {
            onboardingVM.selectedEmotions.append(emotion)
        }
    }
}

#Preview {
    EmotionsSelectionView()
}