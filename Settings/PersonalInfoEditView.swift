//
//  PersonalInfoEditView.swift
//
//  PersonalInfoEditView.swift
//  aura
//
//  Created by Assistant on 5/22/25.
//

import SwiftUI

struct PersonalInfoEditView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authVM: AuthViewModel
    @State private var isLoading = false
    @State private var showingSaveConfirmation = false
    
    // Edit states
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var age = 25
    @State private var gender = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Personal Details Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "person.circle")
                                .font(.title2)
                                .foregroundColor(.blue)
                            
                            Text("Personal Details")
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Spacer()
                        }
                        
                        VStack(spacing: 16) {
                            HStack(spacing: 12) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("First Name")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                    TextField("First Name", text: $firstName)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Last Name")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                    TextField("Last Name", text: $lastName)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                }
                            }
                            
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Age")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                    HStack {
                                        Text("\(age)")
                                            .font(.body)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Stepper("", value: $age, in: 13...100)
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 6)
                                            .stroke(Color(.systemGray4), lineWidth: 1)
                                    )
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Gender (Optional)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                    TextField("Gender", text: $gender)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                }
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemGray6))
                    )
                }
                .padding()
            }
            .navigationTitle("Personal Information")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        savePersonalInfo()
                    }
                    .fontWeight(.semibold)
                    .disabled(isLoading)
                }
            }
        }
        .onAppear {
            loadCurrentInfo()
        }
        .alert("Information Updated", isPresented: $showingSaveConfirmation) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Your personal information has been successfully updated.")
        }
    }
    
    private func loadCurrentInfo() {
        guard let profile = authVM.userProfile else { return }
        
        let nameComponents = profile.name.components(separatedBy: " ")
        firstName = nameComponents.first ?? ""
        lastName = nameComponents.dropFirst().joined(separator: " ")
        age = profile.age
        gender = profile.gender
    }
    
    private func savePersonalInfo() {
        guard let currentProfile = authVM.userProfile else { return }
        
        isLoading = true
        
        let updatedProfile = UserProfile(
            uid: currentProfile.uid,
            name: "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces),
            email: currentProfile.email,
            age: age,
            gender: gender,
            customActions: currentProfile.customActions,
            customUrges: currentProfile.customUrges,
            customGoals: currentProfile.customGoals,
            selectedEmotions: currentProfile.selectedEmotions,
            morningReminderTime: currentProfile.morningReminderTime,
            eveningReminderTime: currentProfile.eveningReminderTime,
            hasCompletedOnboarding: true
        )
        
        updatedProfile.save { [self] success in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if success {
                    authVM.userProfile = updatedProfile
                    showingSaveConfirmation = true
                }
            }
        }
    }
}

#Preview {
    PersonalInfoEditView()
        .environmentObject(AuthViewModel.shared)
}
