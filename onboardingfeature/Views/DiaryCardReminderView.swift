
//
//  DiaryCardReminderView.swift
//  DiaryCardReminderView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/29/25.

import SwiftUI

struct DiaryCardReminderView: View {
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
            
            VStack(spacing: 50) {
                // Elegant header
                VStack(spacing: 20) {
                    Text("Set Your Diary Card Reminders")
                        .font(.system(size: 28, weight: .light, design: .default))
                        .foregroundColor(.primary.opacity(0.9))
                        .multilineTextAlignment(.center)
                    
                    Text("""
                    You can choose to complete your Diary Card once or twice a day. Reflecting on your day can help you track your progress and stay connected to your emotions and experiences.
                    """)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.secondary.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
                .padding(.top, 80)
                .padding(.horizontal, 24)
                
                Spacer()
                
                // Elegant reminder option cards
                VStack(spacing: 24) {
                    // Once per day option
                    Button(action: {
                        OnboardingViewModel.shared.reminderFrequency = .once
                        OnboardingViewModel.shared.onboardingStep = .diaryReminderTimeEvening
                    }) {
                        HStack(spacing: 20) {
                            // Floating icon
                            Image(systemName: "moon.circle")
                                .font(.system(size: 24, weight: .light))
                                .foregroundColor(.primary.opacity(0.8))
                                .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                                .frame(width: 56, height: 56)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Once per day")
                                    .font(.system(size: 19, weight: .medium))
                                    .foregroundColor(.primary.opacity(0.9))
                                
                                Text("Complete your diary card in the evening")
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundColor(.secondary.opacity(0.6))
                            }
                            
                            Spacer()
                            
                            Image(systemName: "arrow.right")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.secondary.opacity(0.4))
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
                    
                    // Twice per day option
                    Button(action: {
                        OnboardingViewModel.shared.reminderFrequency = .twice
                        OnboardingViewModel.shared.onboardingStep = .diaryReminderTimeMorning
                    }) {
                        HStack(spacing: 20) {
                            // Floating icon
                            Image(systemName: "sun.and.horizon.circle")
                                .font(.system(size: 24, weight: .light))
                                .foregroundColor(.primary.opacity(0.8))
                                .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                                .frame(width: 56, height: 56)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Twice per day")
                                    .font(.system(size: 19, weight: .medium))
                                    .foregroundColor(.primary.opacity(0.9))
                                
                                Text("Complete in the morning and evening")
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundColor(.secondary.opacity(0.6))
                            }
                            
                            Spacer()
                            
                            Image(systemName: "arrow.right")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.secondary.opacity(0.4))
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
                .padding(.horizontal, 24)
                
                Spacer()
            }
        }
    }
}

#Preview {
    DiaryCardReminderView()
}
