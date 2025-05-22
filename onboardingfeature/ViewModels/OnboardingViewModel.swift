
//
//
//  OnboardingViewModel.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/30/25.

import Foundation
import FirebaseAuth

// MARK: - Reminder Frequency Enum
enum ReminderFrequency {
    case once
    case twice
}

final class OnboardingViewModel: ObservableObject {
    static let shared = OnboardingViewModel()

    @Published var onboardingStep: OnboardingStep = .welcome
    @Published var hasCompletedOnboarding: Bool = false
    @Published var reminderFrequency: ReminderFrequency = .once
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    
    // MARK: - Collected User Data
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var age: Int = 25
    @Published var gender: String = ""
    
    // Diary Card Customizations
    @Published var selectedActions: [String] = []
    @Published var customActions: [String] = []
    @Published var selectedUrges: [String] = []
    @Published var customUrges: [String] = []
    @Published var selectedGoals: [String] = []
    @Published var customGoals: [String] = []
    @Published var selectedEmotions: [String] = []
    @Published var selectedMedications: [String] = []
    
    // Medication Support
    @Published var takesMedications: Bool = false
    @Published var medications: [Medication] = []
    
    // Reminder Times
    @Published var morningReminderTime: Date = Calendar.current.date(bySettingHour: 8, minute: 30, second: 0, of: Date()) ?? Date()
    @Published var eveningReminderTime: Date = Calendar.current.date(bySettingHour: 20, minute: 0, second: 0, of: Date()) ?? Date()
    
    private init() {
        loadExistingProfile()
    }

    // MARK: - Step Control
    func goToNextStep() {
        guard let currentIndex = OnboardingStep.allCases.firstIndex(of: onboardingStep),
              currentIndex + 1 < OnboardingStep.allCases.count else {
            completeOnboarding()
            return
        }

        onboardingStep = OnboardingStep.allCases[currentIndex + 1]
    }

    func goToPreviousStep() {
        guard let currentIndex = OnboardingStep.allCases.firstIndex(of: onboardingStep),
              currentIndex > 0 else { return }

        onboardingStep = OnboardingStep.allCases[currentIndex - 1]
    }
    
    // MARK: - Data Management
    func updatePersonalInfo(firstName: String? = nil, lastName: String? = nil, age: Int? = nil, gender: String? = nil) {
        if let firstName = firstName { self.firstName = firstName }
        if let lastName = lastName { self.lastName = lastName }
        if let age = age { self.age = age }
        if let gender = gender { self.gender = gender }
        
        print("📝 Updated personal info: \(firstName ?? self.firstName) \(lastName ?? self.lastName), age: \(age ?? self.age)")
    }
    
    func addCustomAction(_ action: String) {
        if !customActions.contains(action) && customActions.count < 3 {
            customActions.append(action)
            print("📝 Added custom action: \(action). Total: \(customActions)")
        }
    }
    
    func addCustomUrge(_ urge: String) {
        if !customUrges.contains(urge) && customUrges.count < 2 {
            customUrges.append(urge)
            print("📝 Added custom urge: \(urge). Total: \(customUrges)")
        }
    }
    
    func addCustomGoal(_ goal: String) {
        if !customGoals.contains(goal) && customGoals.count < 3 {
            customGoals.append(goal)
            print("📝 Added custom goal: \(goal). Total: \(customGoals)")
        }
    }
    
    // MARK: - Medication Management
    func addMedication(_ medication: Medication) {
        if !medications.contains(where: { $0.rxcui == medication.rxcui }) {
            medications.append(medication)
            takesMedications = true
            print("💊 Added medication: \(medication.displayName). Total: \(medications.count)")
        }
    }
    
    func removeMedication(withRxcui rxcui: String) {
        medications.removeAll { $0.rxcui == rxcui }
        takesMedications = !medications.isEmpty
        print("🗑️ Removed medication with RXCUI: \(rxcui). Remaining: \(medications.count)")
    }
    
    func setMedicationTaking(_ taking: Bool) {
        takesMedications = taking
        if !taking {
            medications.removeAll()
        }
        print("💊 Set takes medications: \(taking)")
    }
    
    // MARK: - Load Existing Profile
    private func loadExistingProfile() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("⚠️ No authenticated user found during profile load")
            return
        }
        
        print("🔍 Loading existing profile for user: \(userId)")
        
        UserProfile.fetch(uid: userId) { [weak self] profile in
            guard let self = self, let profile = profile else {
                print("⚠️ No existing profile found")
                return
            }
            
            DispatchQueue.main.async {
                print("✅ Existing profile loaded: \(profile.name)")
                // If user has completed onboarding, load their data
                if profile.hasCompletedOnboarding {
                    self.hasCompletedOnboarding = true
                    self.firstName = profile.name.components(separatedBy: " ").first ?? ""
                    self.lastName = profile.name.components(separatedBy: " ").dropFirst().joined(separator: " ")
                    self.age = profile.age
                    self.gender = profile.gender
                    self.customActions = profile.customActions
                    self.customUrges = profile.customUrges
                    self.customGoals = profile.customGoals
                    self.selectedEmotions = profile.selectedEmotions
                    
                    // Load medication data
                    self.takesMedications = profile.takesMedications
                    self.medications = profile.medications
                    
                    self.morningReminderTime = profile.morningReminderTime ?? self.morningReminderTime
                    self.eveningReminderTime = profile.eveningReminderTime ?? self.eveningReminderTime
                }
            }
        }
    }

    // MARK: - Complete Onboarding
    func completeOnboarding() {
        print("🚀 Starting onboarding completion...")
        
        guard let user = Auth.auth().currentUser else {
            print("❌ No authenticated user found")
            errorMessage = "No authenticated user found"
            return
        }
        
        print("👤 Current user: \(user.uid)")
        print("📝 Collected data:")
        print("   Name: \(firstName) \(lastName)")
        print("   Age: \(age)")
        print("   Gender: \(gender)")
        print("   Custom Actions: \(customActions)")
        print("   Selected Actions: \(selectedActions)")
        print("   Custom Urges: \(customUrges)")
        print("   Custom Goals: \(customGoals)")
        print("   Takes Medications: \(takesMedications)")
        print("   Medications Count: \(medications.count)")
        
        isLoading = true
        errorMessage = ""
        
        // Create updated user profile with all collected data
        let fullName = "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
        let allActions = Array(Set(selectedActions + customActions)).prefix(5).map { $0 }
        let allUrges = Array(Set(selectedUrges + customUrges)).prefix(5).map { $0 }
        let allGoals = Array(Set(selectedGoals + customGoals)).prefix(5).map { $0 }
        
        let updatedProfile = UserProfile(
            uid: user.uid,
            name: fullName,
            email: user.email ?? "",
            age: age,
            gender: gender,
            customActions: Array(allActions),
            customUrges: Array(allUrges),
            customGoals: Array(allGoals),
            selectedEmotions: selectedEmotions,
            takesMedications: takesMedications,
            medications: medications,
            medicationProfileVersion: takesMedications ? 1 : 0,
            morningReminderTime: reminderFrequency == .twice ? morningReminderTime : nil,
            eveningReminderTime: eveningReminderTime,
            hasCompletedOnboarding: true
        )
        
        print("💾 Attempting to save profile...")
        print("   Profile UID: \(updatedProfile.uid)")
        print("   Profile Name: \(updatedProfile.name)")
        print("   Profile Actions: \(updatedProfile.customActions)")
        print("   Profile Medications: \(updatedProfile.medications.count)")
        
        // Save to Firestore
        updatedProfile.save { [weak self] success in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if success {
                    print("🎉 SUCCESS! Profile saved successfully")
                    self?.hasCompletedOnboarding = true
                    // Update AuthViewModel with the new profile
                    AuthViewModel.shared.userProfile = updatedProfile
                    print("✅ AuthViewModel updated with new profile")
                } else {
                    print("❌ FAILED to save profile")
                    self?.errorMessage = "Failed to save profile. Please try again."
                }
            }
        }
    }
    
    // MARK: - Manual Save Test (for debugging)
    func testSave() {
        print("🧪 Testing manual save...")
        firstName = "Test"
        lastName = "User"
        customActions = ["Test Action 1", "Test Action 2"]
        completeOnboarding()
    }
}
