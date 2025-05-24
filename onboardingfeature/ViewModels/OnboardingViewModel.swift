
//
//
//
// Fixed OnboardingViewModel.swift - Properly Save Reminder Times

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
    
    // FIXED: Reminder Times with proper initialization and saving
    @Published var morningReminderTime: Date = Calendar.current.date(bySettingHour: 8, minute: 30, second: 0, of: Date()) ?? Date()
    @Published var eveningReminderTime: Date = Calendar.current.date(bySettingHour: 20, minute: 0, second: 0, of: Date()) ?? Date()
    
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
            self.selectedMedications = []
            
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
    
    // MARK: - FIXED: Reminder Time Management
    func updateMorningReminderTime(_ time: Date) {
        morningReminderTime = time
        print("⏰ Updated morning reminder time to: \(formatTime(time))")
    }
    
    func updateEveningReminderTime(_ time: Date) {
        eveningReminderTime = time
        print("⏰ Updated evening reminder time to: \(formatTime(time))")
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
    
    // MARK: - Load Existing Profile (Only for specific user)
    private func loadExistingProfile(for userId: String) {
        print("🔍 Loading existing profile for user: \(userId)")
        
        UserProfile.fetch(uid: userId) { [weak self] profile in
            guard let self = self, let profile = profile else {
                print("⚠️ No existing profile found for user: \(userId)")
                return
            }
            
            guard profile.uid == userId else {
                print("⚠️ Profile UID mismatch! Expected: \(userId), Got: \(profile.uid)")
                return
            }
            
            DispatchQueue.main.async {
                print("✅ Existing profile loaded for \(profile.name) (UID: \(profile.uid))")
                
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
                    
                    // FIXED: Load reminder times properly
                    if let morningTime = profile.morningReminderTime {
                        self.morningReminderTime = morningTime
                        print("📅 Loaded morning reminder: \(self.formatTime(morningTime))")
                    }
                    if let eveningTime = profile.eveningReminderTime {
                        self.eveningReminderTime = eveningTime
                        print("📅 Loaded evening reminder: \(self.formatTime(eveningTime))")
                    }
                    
                    // Update reminder frequency based on what's saved
                    self.reminderFrequency = (profile.morningReminderTime != nil && profile.eveningReminderTime != nil) ? .twice : .once
                    
                    print("📊 Loaded profile data:")
                    print("   - Has completed onboarding: \(profile.hasCompletedOnboarding)")
                    print("   - Name: \(profile.name)")
                    print("   - Custom Actions: \(profile.customActions)")
                    print("   - Takes Medications: \(profile.takesMedications)")
                    print("   - Morning Reminder: \(profile.morningReminderTime?.formatted(date: .omitted, time: .shortened) ?? "none")")
                    print("   - Evening Reminder: \(profile.eveningReminderTime?.formatted(date: .omitted, time: .shortened) ?? "none")")
                } else {
                    print("📝 User has profile but hasn't completed onboarding yet")
                    self.hasCompletedOnboarding = false
                }
            }
        }
    }

    // MARK: - ENHANCED: Complete Onboarding with Proper Reminder Time Handling
    func completeOnboarding() {
        print("🚀 Starting onboarding completion...")
        
        guard let user = Auth.auth().currentUser else {
            print("❌ No authenticated user found")
            errorMessage = "No authenticated user found"
            return
        }
        
        guard user.uid == currentUserId else {
            print("❌ User ID mismatch during completion!")
            errorMessage = "User authentication error"
            return
        }
        
        print("👤 Completing onboarding for user: \(user.uid)")
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
        print("   Reminder Frequency: \(reminderFrequency)")
        print("   Morning Time: \(formatTime(morningReminderTime))")
        print("   Evening Time: \(formatTime(eveningReminderTime))")
        
        isLoading = true
        errorMessage = ""
        
        // Create updated user profile with all collected data
        let fullName = "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
        let allActions = Array(Set(selectedActions + customActions)).prefix(5).map { $0 }
        let allUrges = Array(Set(selectedUrges + customUrges)).prefix(5).map { $0 }
        let allGoals = Array(Set(selectedGoals + customGoals)).prefix(5).map { $0 }
        
        // FIXED: Properly set reminder times based on user selection
        let finalMorningTime: Date? = (reminderFrequency == .twice) ? morningReminderTime : nil
        let finalEveningTime: Date? = eveningReminderTime  // Always save evening time
        
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
            morningReminderTime: finalMorningTime,
            eveningReminderTime: finalEveningTime,
            hasCompletedOnboarding: true
        )
        
        print("💾 Attempting to save profile...")
        print("   Profile UID: \(updatedProfile.uid)")
        print("   Morning Reminder: \(updatedProfile.morningReminderTime?.formatted(date: .omitted, time: .shortened) ?? "none")")
        print("   Evening Reminder: \(updatedProfile.eveningReminderTime?.formatted(date: .omitted, time: .shortened) ?? "none")")
        
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
                    
                    // 🔔 CRITICAL: Setup notifications with the saved profile
                    print("🔔 Setting up notifications with saved profile...")
                    Task {
                        await SimpleNotificationService.shared.setupNotifications(for: updatedProfile)
                        
                        // Debug: List what was scheduled
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            SimpleNotificationService.shared.listScheduledNotifications()
                        }
                    }
                    
                } else {
                    print("❌ FAILED to save profile")
                    self?.errorMessage = "Failed to save profile. Please try again."
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
