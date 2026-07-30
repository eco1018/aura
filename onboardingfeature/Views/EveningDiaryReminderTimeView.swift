
//
//
//  EveningDiaryReminderTimeView.swift
//  aura
//
//
//  EveningDiaryReminderTimeView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/30/25.
//
// Fixed EveningDiaryReminderTimeView.swift - Only Evening View

import SwiftUI

struct EveningDiaryReminderTimeView: View {
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
                    Text("Set Evening Reminder Time")
                        .font(.system(size: 28, weight: .light, design: .default))
                        .foregroundColor(.primary.opacity(0.9))
                        .multilineTextAlignment(.center)
                    
                    Text("Choose a time to be reminded to complete your evening Diary Card.")
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
                    Text("Evening Reminder")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.primary.opacity(0.9))
                    
<<<<<<< HEAD
                    DatePicker("Evening Reminder", selection: $onboardingVM.eveningReminderTime, displayedComponents: .hourAndMinute)
=======
                    DatePicker("Evening Reminder", selection: $selectedTime, displayedComponents: .hourAndMinute)
>>>>>>> origin/New_Main
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                        .frame(height: 120)
                        .clipped()
                        .onChange(of: selectedTime) { _, newTime in
                            // FIXED: Actually save the selected time
                            onboardingVM.updateEveningReminderTime(newTime)
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
                
<<<<<<< HEAD
                // Elegant finish button (using checkmark since this might be the last step before wrap up)
                Button(action: {
                    print("📝 Evening reminder time set: \(onboardingVM.eveningReminderTime.formatted(date: .omitted, time: .shortened))")
=======
                // Finish button
                Button(action: {
                    // Save the final time and complete onboarding
                    onboardingVM.updateEveningReminderTime(selectedTime)
                    print("⏰ Saved evening reminder time: \(selectedTime.formatted(date: .omitted, time: .shortened))")
                    
                    // Go to wrap up
>>>>>>> origin/New_Main
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
            selectedTime = onboardingVM.eveningReminderTime
            print("📱 Evening reminder view appeared - current time: \(selectedTime.formatted(date: .omitted, time: .shortened))")
        }
    }
}

#Preview {
    EveningDiaryReminderTimeView()
}
