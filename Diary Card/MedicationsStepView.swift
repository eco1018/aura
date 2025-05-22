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
        ScrollView {
            VStack(spacing: 24) {
                // Header section
                VStack(spacing: 8) {
                    Image(systemName: DiaryStep.medications.systemImage)
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                    
                    Text(DiaryStep.medications.title)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(DiaryStep.medications.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top)
                
                // Main question
                VStack(spacing: 20) {
                    Text("Did you take your medications as prescribed today?")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    // Yes/No buttons
                    HStack(spacing: 20) {
                        // No button
                        Button(action: {
                            tookMedication = false
                            diaryEntry.updateMedicationCompliance(took: false, notes: additionalNotes)
                        }) {
                            VStack(spacing: 8) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.title)
                                    .foregroundColor(tookMedication ? .gray : .red)
                                
                                Text("No")
                                    .font(.headline)
                                    .fontWeight(.medium)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(tookMedication ? Color(.systemGray6) : Color.red.opacity(0.1))
                                    .stroke(tookMedication ? Color.clear : Color.red.opacity(0.3), lineWidth: 2)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        // Yes button
                        Button(action: {
                            tookMedication = true
                            diaryEntry.updateMedicationCompliance(took: true, notes: additionalNotes)
                        }) {
                            VStack(spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.title)
                                    .foregroundColor(tookMedication ? .green : .gray)
                                
                                Text("Yes")
                                    .font(.headline)
                                    .fontWeight(.medium)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(tookMedication ? Color.green.opacity(0.1) : Color(.systemGray6))
                                    .stroke(tookMedication ? Color.green.opacity(0.3) : Color.clear, lineWidth: 2)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal)
                }
                
                // Status message
                if tookMedication {
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.green)
                        Text("Great job staying consistent with your medication routine!")
                            .font(.subheadline)
                            .foregroundColor(.green)
                            .fontWeight(.medium)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.green.opacity(0.1))
                    )
                } else {
                    VStack(spacing: 8) {
                        HStack {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(.orange)
                            Text("That's okay - consistency takes time to build.")
                                .font(.subheadline)
                                .foregroundColor(.orange)
                                .fontWeight(.medium)
                        }
                        
                        Text("Consider setting a daily reminder or talking to your healthcare provider about any challenges.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.orange.opacity(0.1))
                    )
                }
                
                // Optional notes section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Additional Notes (Optional)")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text("Any thoughts about your medication today?")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    TextField("Side effects, timing, reminders needed, etc.", text: $additionalNotes, axis: .vertical)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .lineLimit(3...6)
                        .onChange(of: additionalNotes) { _, newValue in
                            diaryEntry.updateMedicationCompliance(took: tookMedication, notes: newValue)
                        }
                }
                .padding(.horizontal)
                
                Spacer(minLength: 100)
            }
            .padding()
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