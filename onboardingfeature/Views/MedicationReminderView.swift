
//
//  MedicationReminderView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/29/25.
//

import SwiftUI

struct MedicationReminderView: View {
    @State private var morningTime = Date()
    
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
                    Text("Set Medication Reminders")
                        .font(.system(size: 28, weight: .light, design: .default))
                        .foregroundColor(.primary.opacity(0.9))
                        .multilineTextAlignment(.center)
                    
                    Text("""
                    Let's set up reminders for your medication. You can choose a time in the morning and in the evening to make sure you take your meds consistently.
                    """)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.secondary.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
                .padding(.top, 80)
                .padding(.horizontal, 24)
                
                Spacer()
                
                // Glassmorphic time picker card
                VStack(spacing: 24) {
                    Text("Morning Reminder")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.primary.opacity(0.9))
                    
                    DatePicker("Morning Reminder", selection: $morningTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                        .frame(height: 120)
                        .clipped()
                }
                .padding(28)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color(.systemBackground).opacity(0.8))
                        .background(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.04), radius: 16, x: 0, y: 6)
                        .shadow(color: .black.opacity(0.02), radius: 1, x: 0, y: 1)
                )
                .padding(.horizontal, 24)
                
                Spacer()
                
                // Standard next button (exact match to other onboarding views)
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
    MedicationReminderView()
}
