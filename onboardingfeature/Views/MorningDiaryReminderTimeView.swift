//
//
//  MorningDiaryReminderTimeView.swift
//  aura
//
//
<<<<<<< HEAD
//  MorningDiaryReminderTimeView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/30/25.
//
=======
// Fixed MorningDiaryReminderTimeView.swift - Only Morning View
>>>>>>> origin/New_Main

import SwiftUI

struct MorningDiaryReminderTimeView: View {
    @ObservedObject var onboardingVM = OnboardingViewModel.shared
<<<<<<< HEAD
=======
    @State private var selectedTime: Date = Date()
>>>>>>> origin/New_Main

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
                    Text("Set Morning Reminder Time")
                        .font(.system(size: 28, weight: .light, design: .default))
                        .foregroundColor(.primary.opacity(0.9))
                        .multilineTextAlignment(.center)
                    
                    Text("Choose a time to be reminded to complete your morning Diary Card.")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.secondary.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
                .padding(.top, 80)
                .padding(.horizontal, 24)
                
                Spacer()
                
                // Glassmorphic time picker card - NOW CONNECTED TO VIEW MODEL
                VStack(spacing: 24) {
                    Text("Morning Reminder")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.primary.opacity(0.9))
                    
<<<<<<< HEAD
                    DatePicker("Morning Reminder", selection: $onboardingVM.morningReminderTime, displayedComponents: .hourAndMinute)
=======
                    DatePicker("Morning Reminder", selection: $selectedTime, displayedComponents: .hourAndMinute)
>>>>>>> origin/New_Main
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                        .frame(height: 120)
                        .clipped()
                        .onChange(of: selectedTime) { _, newTime in
                            // FIXED: Actually save the selected time
                            onboardingVM.updateMorningReminderTime(newTime)
                        }
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
                
                // Standard next button
                Button(action: {
<<<<<<< HEAD
                    print("📝 Morning reminder time set: \(onboardingVM.morningReminderTime.formatted(date: .omitted, time: .shortened))")
                    
                    // Navigate based on reminder frequency
                    if onboardingVM.reminderFrequency == .twice {
                        onboardingVM.onboardingStep = .diaryReminderTimeEvening
                    } else {
                        onboardingVM.goToNextStep() // Skip evening reminder
                    }
=======
                    // Save the final time and proceed
                    onboardingVM.updateMorningReminderTime(selectedTime)
                    print("⏰ Saved morning reminder time: \(selectedTime.formatted(date: .omitted, time: .shortened))")
                    
                    // Go to evening time or wrap up based on frequency
                    onboardingVM.onboardingStep = .diaryReminderTimeEvening
>>>>>>> origin/New_Main
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
        .onAppear {
            // Initialize with the current value from onboarding
            selectedTime = onboardingVM.morningReminderTime
            print("📱 Morning reminder view appeared - current time: \(selectedTime.formatted(date: .omitted, time: .shortened))")
        }
    }
}

#Preview {
    MorningDiaryReminderTimeView()
}
