//
//  MedicationsStepView.swift
//  aura
//
//  Created by Ella A. Sadduq on 5/22/25.
//

//
//  MedicationsStepView.swift
//  aura
//
//  Created by Ella A. Sadduq on 5/22/25.
//

import SwiftUI

struct MedicationsStepView: View {
    @ObservedObject var diaryEntry: DiaryEntryViewModel
    @State private var tookMedication: Bool = false
    @State private var additionalNotes: String = ""
    
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
                
                VStack(spacing: 60) {
                    // Elegant header
                    VStack(spacing: 20) {
                        Text("Medications")
                            .font(.system(size: 34, weight: .light, design: .default))
                            .foregroundColor(.primary.opacity(0.9))
                        
                        Text("Did you take your medications as prescribed today?")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.secondary.opacity(0.7))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 80)
                    
                    Spacer()
                    
                    // Glassmorphic Yes/No cards
                    HStack(spacing: 24) {
                        // No button
                        Button(action: {
                            withAnimation(.spring(response: 0.4)) {
                                tookMedication = false
                                diaryEntry.updateMedicationCompliance(took: false, notes: additionalNotes)
                            }
                        }) {
                            VStack(spacing: 16) {
                                Image(systemName: "xmark.circle")
                                    .font(.system(size: 32, weight: .light))
                                    .foregroundColor(.primary.opacity(0.8))
                                    .shadow(color: .primary.opacity(0.1), radius: 2, x: 1, y: 1)
                                    .shadow(color: .white.opacity(0.8), radius: 1, x: -0.5, y: -0.5)
                                
                                Text("No")
                                    .font(.system(size: 19, weight: .medium))
                                    .foregroundColor(.primary.opacity(0.9))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 32)
                            .padding(.horizontal, 20)
                            .background(
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(Color(.systemBackground).opacity(tookMedication ? 0.5 : 0.8))
                                    .background(
                                        RoundedRectangle(cornerRadius: 24)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                                    .shadow(color: .black.opacity(tookMedication ? 0.02 : 0.04), radius: tookMedication ? 10 : 20, x: 0, y: tookMedication ? 4 : 8)
                                    .shadow(color: .black.opacity(tookMedication ? 0.01 : 0.02), radius: 1, x: 0, y: 1)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        .scaleEffect(!tookMedication ? 1.0 : 0.95)
                        .animation(.spring(response: 0.4), value: tookMedication)
                        
                        // Yes button
                        Button(action: {
                            withAnimation(.spring(response: 0.4)) {
                                tookMedication = true
                                diaryEntry.updateMedicationCompliance(took: true, notes: additionalNotes)
                            }
                        }) {
                            VStack(spacing: 16) {
                                Image(systemName: "checkmark.circle")
                                    .font(.system(size: 32, weight: .light))
                                    .foregroundColor(.primary.opacity(0.8))
                                    .shadow(color: .primary.opacity(0.1), radius: 2, x: 1, y: 1)
                                    .shadow(color: .white.opacity(0.8), radius: 1, x: -0.5, y: -0.5)
                                
                                Text("Yes")
                                    .font(.system(size: 19, weight: .medium))
                                    .foregroundColor(.primary.opacity(0.9))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 32)
                            .padding(.horizontal, 20)
                            .background(
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(Color(.systemBackground).opacity(tookMedication ? 0.8 : 0.5))
                                    .background(
                                        RoundedRectangle(cornerRadius: 24)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                                    .shadow(color: .black.opacity(tookMedication ? 0.04 : 0.02), radius: tookMedication ? 20 : 10, x: 0, y: tookMedication ? 8 : 4)
                                    .shadow(color: .black.opacity(tookMedication ? 0.02 : 0.01), radius: 1, x: 0, y: 1)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        .scaleEffect(tookMedication ? 1.0 : 0.95)
                        .animation(.spring(response: 0.4), value: tookMedication)
                    }
                    .padding(.horizontal, 28)
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            // Load existing values if any
            tookMedication = diaryEntry.getMedicationCompliance()
            additionalNotes = diaryEntry.getMedicationNotes()
        }
    }
}

#Preview {
    MedicationsStepView(diaryEntry: DiaryEntryViewModel(session: .manual))
}
