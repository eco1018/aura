
//
//
//
//
//  OnboardingViewModel.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/30/25.
//
//
//  OnboardingViewModel.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/30/25.
//

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
    @Published var firstName: String = "" {
        didSet {
            print("📝 FirstName updated: \(firstName)")
        }
    }
    @Published var lastName: String = "" {
        didSet {
            print("📝 LastName updated: \(lastName)")
        }
    }
    @Published var age: Int = 25 {
        didSet {
            print("📝 Age updated: \(age)")
        }
    }
    @Published var gender: String = "" {
        didSet {
            print("📝 Gender updated: \(gender)")
        }
    }
    
    // Diary Card Customizations
    @Published var selectedActions: [String] = [] {
        didSet {
            print("📝 Selected actions updated: \(selectedActions)")
        }
    }
    @Published var customActions: [String] = [] {
        didSet {
            print("📝 Custom actions updated: \(customActions)")
        }
    }
    @Published var selectedUrges: [String] = [] {
        didSet {
            print("📝 Selected urges updated: \(selectedUrges)")
        }
    }
    @Published var customUrges: [String] = [] {
        didSet {
            print("📝 Custom urges updated: \(customUrges)")
        }
    }
    @Published var selectedGoals: [String] = [] {
        didSet {
            print("📝 Selected goals updated: \(selectedGoals)")
        }
    }
    @Published var customGoals: [String] = [] {
        didSet {
            print("📝 Custom goals updated: \(customGoals)")
        }
    }
    @Published var selectedEmotions: [String] = [] {
        didSet {
            print("📝 Selected emotions updated: \(selectedEmotions)")
        }
    }
    
    // Medication Support
    @Published var takesMedications: Bool = false {
        didSet {
            print("📝 Takes medications updated: \(takesMedications)")
        }
    }
    @Published var medications: [Medication] = [] {
        didSet {
            print("📝 Medications updated: \(medications.count) medications")
        }
    }
    
    // Reminder Times
    @Published var morningReminderTime: Date = Calendar.current.date(bySettingHour: 8, minute: 30, second: 0, of: Date()) ?? Date() {
        didSet {
            print("📝 Morning reminder time updated: \(formatTime(morningReminderTime))")
        }
    }
    @Published var eveningReminderTime: Date = Calendar.current.date(bySettingHour: 20, minute: 0, second: 0, of: Date()) ?? Date() {
        didSet {
            print("📝 Evening reminder time updated: \(formatTime(eveningReminderTime))")
        }
    }
    
    // Track the current user to detect user changes
    private var currentUserId: String?
    
    private init() {
        setupAuthListener()
    }
    
    // MARK: - Auth State Management
    private func setupAuthListener() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.handleAuthStateChange(user: user)
            }
        }
    }
    
    private func handleAuthStateChange(user: User?) {
        let newUserId = user?.uid
        
        // If user changed, reset everything
        if newUserId != currentUserId {
            currentUserId = newUserId
            
            if let userId = newUserId {
                print("🔄 User changed to: \(userId)")
                resetOnboardingData()
                loadExistingProfile(for: userId)
            } else {
                print("🔄 User signed out")
                resetOnboardingData()
            }
        }
    }
    
    // MARK: - Data Reset
    private func resetOnboardingData() {
        print("🔄 Resetting onboarding data")
        
        DispatchQueue.main.async {
            self.onboardingStep = .welcome
            self.hasCompletedOnboarding = false
            self.reminderFrequency = .once
            self.isLoading = false
            self.errorMessage = ""
            
            // Reset user data
            self.firstName = ""
            self.lastName = ""
            self.age = 25
            self.gender = ""
            
            // Reset diary card customizations
            self.selectedActions = []
            self.customActions = []
            self.selectedUrges = []
            self.customUrges = []
            self.selectedGoals = []
            self.customGoals = []
            self.selectedEmotions = []
            
            // Reset medication support
            self.takesMedications = false
            self.medications = []
            
            // Reset reminder times to defaults
            self.morningReminderTime = Calendar.current.date(bySettingHour: 8, minute: 30, second: 0, of: Date()) ?? Date()
            self.eveningReminderTime = Calendar.current.date(bySettingHour: 20, minute: 0, second: 0, of: Date()) ?? Date()
        }
    }
    
    // MARK: - Public Methods for Fresh Start
    func startFreshOnboarding() {
        print("🆕 Starting fresh onboarding")
        resetOnboardingData()
    }

    // MARK: - Step Control
    func goToNextStep() {
        // Print current data state before proceeding
        printCurrentDataState()
        
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
    
    // MARK: - Helper Methods for Data Management
    func addCustomAction(_ action: String) {
        let trimmedAction = action.trimmingCharacters(in: .whitespaces)
        if !trimmedAction.isEmpty && !customActions.contains(trimmedAction) && customActions.count < 3 {
            customActions.append(trimmedAction)
            print("📝 Added custom action: \(trimmedAction). Total: \(customActions)")
        }
    }
    
    func removeCustomAction(_ action: String) {
        customActions.removeAll { $0 == action }
        print("🗑️ Removed custom action: \(action)")
    }
    
    func addCustomUrge(_ urge: String) {
        let trimmedUrge = urge.trimmingCharacters(in: .whitespaces)
        if !trimmedUrge.isEmpty && !customUrges.contains(trimmedUrge) && customUrges.count < 2 {
            customUrges.append(trimmedUrge)
            print("📝 Added custom urge: \(trimmedUrge). Total: \(customUrges)")
        }
    }
    
    func removeCustomUrge(_ urge: String) {
        customUrges.removeAll { $0 == urge }
        print("🗑️ Removed custom urge: \(urge)")
    }
    
    func addCustomGoal(_ goal: String) {
        let trimmedGoal = goal.trimmingCharacters(in: .whitespaces)
        if !trimmedGoal.isEmpty && !customGoals.contains(trimmedGoal) && customGoals.count < 3 {
            customGoals.append(trimmedGoal)
            print("📝 Added custom goal: \(trimmedGoal). Total: \(customGoals)")
        }
    }
    
    func removeCustomGoal(_ goal: String) {
        customGoals.removeAll { $0 == goal }
        print("🗑️ Removed custom goal: \(goal)")
    }
    
    func toggleActionSelection(_ action: String) {
        if selectedActions.contains(action) {
            selectedActions.removeAll { $0 == action }
        } else if (selectedActions.count + customActions.count) < 3 {
            selectedActions.append(action)
        }
    }
    
    func toggleUrgeSelection(_ urge: String) {
        if selectedUrges.contains(urge) {
            selectedUrges.removeAll { $0 == urge }
        } else if (selectedUrges.count + customUrges.count) < 2 {
            selectedUrges.append(urge)
        }
    }
    
    func toggleGoalSelection(_ goal: String) {
        if selectedGoals.contains(goal) {
            selectedGoals.removeAll { $0 == goal }
        } else if (selectedGoals.count + customGoals.count) < 3 {
            selectedGoals.append(goal)
        }
    }
    
    func toggleEmotionSelection(_ emotion: String) {
        if selectedEmotions.contains(emotion) {
            selectedEmotions.removeAll { $0 == emotion }
        } else if selectedEmotions.count < 6 {
            selectedEmotions.append(emotion)
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
    
    // MARK: - Data State Debugging
    private func printCurrentDataState() {
        print("📊 Current Onboarding Data State:")
        print("   - Step: \(onboardingStep)")
        print("   - Name: '\(firstName)' '\(lastName)'")
        print("   - Age: \(age)")
        print("   - Gender: '\(gender)'")
        print("   - Selected Actions: \(selectedActions)")
        print("   - Custom Actions: \(customActions)")
        print("   - Selected Urges: \(selectedUrges)")
        print("   - Custom Urges: \(customUrges)")
        print("   - Selected Goals: \(selectedGoals)")
        print("   - Custom Goals: \(customGoals)")
        print("   - Selected Emotions: \(selectedEmotions)")
        print("   - Takes Medications: \(takesMedications)")
        print("   - Medications: \(medications.count)")
        print("   - Reminder Frequency: \(reminderFrequency)")
    }
    
    // MARK: - Load Existing Profile (Only for specific user)
    private func loadExistingProfile(for userId: String) {
        print("🔍 Loading existing profile for user: \(userId)")
        
        UserProfile.fetch(uid: userId) { [weak self] profile in
            guard let self = self, let profile = profile else {
                print("⚠️ No existing profile found for user: \(userId)")
                return
            }
            
            // Double-check the profile belongs to the correct user
            guard profile.uid == userId else {
                print("⚠️ Profile UID mismatch! Expected: \(userId), Got: \(profile.uid)")
                return
            }
            
            DispatchQueue.main.async {
                print("✅ Existing profile loaded for \(profile.name) (UID: \(profile.uid))")
                
                // If user has completed onboarding, load their data
                if profile.hasCompletedOnboarding {
                    self.hasCompletedOnboarding = true
                    
                    // Parse name components
                    let nameComponents = profile.name.components(separatedBy: " ")
                    self.firstName = nameComponents.first ?? ""
                    self.lastName = nameComponents.dropFirst().joined(separator: " ")
                    
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
                    
                    print("📊 Loaded profile data:")
                    print("   - Has completed onboarding: \(profile.hasCompletedOnboarding)")
                    print("   - Name: \(profile.name)")
                    print("   - Custom Actions: \(profile.customActions)")
                    print("   - Takes Medications: \(profile.takesMedications)")
                } else {
                    print("📝 User has profile but hasn't completed onboarding yet")
                    self.hasCompletedOnboarding = false
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
        
        // Double-check we're working with the right user
        guard user.uid == currentUserId else {
            print("❌ User ID mismatch during completion!")
            errorMessage = "User authentication error"
            return
        }
        
        // Print final data state before saving
        printCurrentDataState()
        
        print("👤 Completing onboarding for user: \(user.uid)")
        
        isLoading = true
        errorMessage = ""
        
        // Create updated user profile with all collected data
        let fullName = "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
        let allActions = Array(Set(selectedActions + customActions)).prefix(5).map { $0 }
        let allUrges = Array(Set(selectedUrges + customUrges)).prefix(5).map { $0 }
        let allGoals = Array(Set(selectedGoals + customGoals)).prefix(5).map { $0 }
        
        // Validate required fields
        if fullName.isEmpty {
            print("❌ Name is empty!")
            isLoading = false
            errorMessage = "Please enter your name"
            return
        }
        
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
        
        print("💾 Final profile to save:")
        print("   Profile UID: \(updatedProfile.uid)")
        print("   Profile Name: '\(updatedProfile.name)'")
        print("   Profile Age: \(updatedProfile.age)")
        print("   Profile Gender: '\(updatedProfile.gender)'")
        print("   Profile Actions: \(updatedProfile.customActions)")
        print("   Profile Urges: \(updatedProfile.customUrges)")
        print("   Profile Goals: \(updatedProfile.customGoals)")
        print("   Profile Emotions: \(updatedProfile.selectedEmotions)")
        print("   Profile Medications: \(updatedProfile.medications.count)")
        print("   Profile Takes Meds: \(updatedProfile.takesMedications)")
        
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
                    
                    // 🔔 Setup notifications after successful save
                    Task {
                        await SimpleNotificationService.shared.setupNotifications(for: updatedProfile)
                    }
                    
                } else {
                    print("❌ FAILED to save profile")
                    self?.errorMessage = "Failed to save profile. Please try again."
                }
            }
        }
    }
    
    // MARK: - Utility Methods
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    // MARK: - Manual Save Test (for debugging)
    func testSave() {
        print("🧪 Testing manual save...")
        firstName = "Test"
        lastName = "User"
        age = 30
        customActions = ["Test Action 1", "Test Action 2"]
        completeOnboarding()
    }
}
