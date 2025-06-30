//
//  AuthCoordinator.swift
//  aura
//
//
//  AuthCoordinator.swift
//  aura
//
//  Auth Coordinator for managing authentication flow

import SwiftUI
import FirebaseAuth

// MARK: - Auth Coordinator Protocol
protocol AuthCoordinatorProtocol: ObservableObject {
    var currentView: AuthCoordinatorState { get set }
    var authViewModel: AuthViewModel { get }
    
    func navigateTo(_ view: AuthCoordinatorState)
    func handleAuthSuccess()
    func handleSignOut()
    func reset()
}

// MARK: - Auth Coordinator States
enum AuthCoordinatorState: Equatable {
    case signIn
    case signUp
    case forgotPassword
    case loading
    case authenticated
}

// MARK: - Auth Coordinator Implementation
@MainActor
final class AuthCoordinator: AuthCoordinatorProtocol {
    
    // MARK: - Published Properties
    @Published var currentView: AuthCoordinatorState = .signIn
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    
    // MARK: - Dependencies
    let authViewModel: AuthViewModel
    private var authStateListener: AuthStateDidChangeListenerHandle?
    
    // MARK: - Initialization
    init(authViewModel: AuthViewModel = AuthViewModel.shared) {
        self.authViewModel = authViewModel
        setupAuthStateListener()
        determineInitialView()
    }
    
    deinit {
        if let listener = authStateListener {
            Auth.auth().removeStateDidChangeListener(listener)
        }
    }
    
    // MARK: - Public Methods
    func navigateTo(_ view: AuthCoordinatorState) {
        print("🧭 AuthCoordinator: Navigating to \(view)")
        currentView = view
    }
    
    func handleAuthSuccess() {
        print("🎉 AuthCoordinator: Authentication successful")
        currentView = .authenticated
    }
    
    func handleSignOut() {
        print("🚪 AuthCoordinator: Handling sign out")
        authViewModel.signOut()
        reset()
    }
    
    func reset() {
        print("🔄 AuthCoordinator: Resetting to initial state")
        currentView = .signIn
        isLoading = false
        errorMessage = ""
        showError = false
    }
    
    func clearError() {
        errorMessage = ""
        showError = false
    }
    
    // MARK: - Auth Actions (Coordinated through ViewModel)
    func signIn(email: String, password: String) {
        guard !email.isEmpty && !password.isEmpty else {
            showErrorMessage("Please fill in all fields")
            return
        }
        
        isLoading = true
        clearError()
        
        // Use existing AuthViewModel method
        authViewModel.signIn(email: email, password: password)
    }
    
    func signUp(name: String, email: String, password: String, confirmPassword: String) {
        // Validation
        guard !name.isEmpty && !email.isEmpty && !password.isEmpty else {
            showErrorMessage("Please fill in all fields")
            return
        }
        
        guard password == confirmPassword else {
            showErrorMessage("Passwords do not match")
            return
        }
        
        guard password.count >= 6 else {
            showErrorMessage("Password must be at least 6 characters")
            return
        }
        
        isLoading = true
        clearError()
        
        // Use existing AuthViewModel method
        authViewModel.signUp(name: name, email: email, password: password)
    }
    
    func resetPassword(email: String) {
        guard !email.isEmpty else {
            showErrorMessage("Please enter your email address")
            return
        }
        
        isLoading = true
        clearError()
        
        authViewModel.resetPassword(email: email)
        
        // Show success message and navigate back
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isLoading = false
            self.showSuccessMessage("Password reset email sent")
            self.navigateTo(.signIn)
        }
    }
    
    // MARK: - Private Methods
    private func setupAuthStateListener() {
        authStateListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                
                if user != nil {
                    print("✅ AuthCoordinator: User authenticated")
                    self.handleAuthSuccess()
                } else {
                    print("❌ AuthCoordinator: User not authenticated")
                    if self.currentView == .authenticated {
                        self.reset()
                    }
                }
            }
        }
    }
    
    private func determineInitialView() {
        if Auth.auth().currentUser != nil {
            currentView = .authenticated
        } else {
            currentView = .signIn
        }
    }
    
    private func showErrorMessage(_ message: String) {
        errorMessage = message
        showError = true
        isLoading = false
    }
    
    private func showSuccessMessage(_ message: String) {
        // You could add a success message system here
        print("✅ Success: \(message)")
    }
}

// MARK: - Auth Coordinator Main View
struct AuthCoordinatorMainView: View {
    @StateObject private var coordinator = AuthCoordinator()
    
    var body: some View {
        Group {
            switch coordinator.currentView {
            case .loading:
                LoadingView()
                
            case .signIn:
                SignInView()
                    .environmentObject(coordinator)
                
            case .signUp:
                SignUpView()
                    .environmentObject(coordinator)
                
            case .forgotPassword:
                ForgotPasswordView()
                    .environmentObject(coordinator)
                
            case .authenticated:
                // This would transition to your main app flow
                // or could emit an event that RootView listens to
                EmptyView()
            }
        }
        .alert("Error", isPresented: $coordinator.showError) {
            Button("OK") {
                coordinator.clearError()
            }
        } message: {
            Text(coordinator.errorMessage)
        }
    }
}

// MARK: - Coordinated Sign In View
struct SignInCoordinatedView: View {
    @EnvironmentObject var coordinator: AuthCoordinator
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isEmailFocused: Bool = false
    @State private var isPasswordFocused: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Your existing background styling
                Color.white.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        Spacer(minLength: 100)
                        
                        // Header Section (your existing styling)
                        headerSection
                        
                        // Form Container (your existing styling)
                        formSection
                        
                        // Action Buttons (your existing styling)
                        actionSection
                        
                        Spacer(minLength: 40)
                    }
                }
                
                // Loading overlay
                if coordinator.isLoading {
                    LoadingOverlay()
                }
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 32) {
            ZStack {
                Circle()
                    .fill(Color.black)
                    .frame(width: 60, height: 60)
                    .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 8)
                
                Image(systemName: "person.circle")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.white)
            }
            
            Text("Welcome Back")
                .font(.system(size: 28, weight: .light, design: .default))
                .foregroundColor(.black)
                .tracking(0.5)
        }
        .padding(.bottom, 60)
    }
    
    private var formSection: some View {
        VStack(spacing: 32) {
            // Email Field
            VStack(alignment: .leading, spacing: 12) {
                Text("Email")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.black.opacity(0.7))
                    .tracking(0.3)
                
                TextField("Enter your email address", text: $email, onEditingChanged: { focused in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isEmailFocused = focused
                    }
                })
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .textContentType(.emailAddress)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.black)
                .padding(.horizontal, 0)
                .padding(.vertical, 16)
                .background(Color.clear)
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(isEmailFocused ? .black : .gray.opacity(0.3))
                        .animation(.easeInOut(duration: 0.2), value: isEmailFocused),
                    alignment: .bottom
                )
            }
            
            // Password Field
            VStack(alignment: .leading, spacing: 12) {
                Text("Password")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.black.opacity(0.7))
                    .tracking(0.3)
                
                SecureField("Enter your password", text: $password)
                    .textContentType(.password)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.black)
                    .padding(.horizontal, 0)
                    .padding(.vertical, 16)
                    .background(Color.clear)
                    .overlay(
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(isPasswordFocused ? .black : .gray.opacity(0.3))
                            .animation(.easeInOut(duration: 0.2), value: isPasswordFocused),
                        alignment: .bottom
                    )
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isPasswordFocused = true
                        }
                    }
            }
        }
        .padding(.horizontal, 40)
        .padding(.bottom, 50)
    }
    
    private var actionSection: some View {
        VStack(spacing: 32) {
            // Sign In Button
            Button(action: {
                coordinator.signIn(email: email, password: password)
            }) {
                Text("Sign In")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .tracking(0.5)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Color.black)
                    .clipShape(RoundedRectangle(cornerRadius: 26))
                    .shadow(color: Color.black.opacity(0.15), radius: 15, x: 0, y: 8)
            }
            .disabled(coordinator.isLoading)
            
            // Secondary Actions
            VStack(spacing: 20) {
                Button(action: {
                    coordinator.navigateTo(.forgotPassword)
                }) {
                    Text("Forgot Password?")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.black)
                        .tracking(0.2)
                }
                
                Button(action: {
                    coordinator.navigateTo(.signUp)
                }) {
                    HStack(spacing: 6) {
                        Text("Don't have an account?")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.gray)
                            .tracking(0.2)
                        
                        Text("Sign Up")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.black)
                            .tracking(0.2)
                    }
                }
            }
        }
        .padding(.horizontal, 40)
        .padding(.bottom, 60)
    }
}

// MARK: - Supporting Views
struct LoadingView: View {
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
            
            Text("Loading...")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

struct LoadingOverlay: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                ProgressView()
                    .scaleEffect(1.2)
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                
                Text("Please wait...")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.8))
            )
        }
    }
}

// MARK: - Integration with RootView
struct RootViewWithCoordinator: View {
    @StateObject private var authCoordinator = AuthCoordinator()
    @StateObject private var onboardingVM = OnboardingViewModel.shared
    
    var body: some View {
        Group {
            if !authCoordinator.authViewModel.isAuthenticated {
                AuthCoordinatorMainView()
            } else if !onboardingVM.hasCompletedOnboarding {
                OnboardingFlowView()
                    .environmentObject(onboardingVM)
            } else {
                MainView()
                    .environmentObject(authCoordinator.authViewModel)
            }
        }
        .onAppear {
            print("📱 RootViewWithCoordinator appeared")
            print("   - Authenticated: \(authCoordinator.authViewModel.isAuthenticated)")
            print("   - Onboarding Complete: \(onboardingVM.hasCompletedOnboarding)")
        }
    }
}

// MARK: - Placeholder Views for Sign Up and Forgot Password (Remove these - use your actual views)
struct SignUpCoordinatedView: View {
    @EnvironmentObject var coordinator: AuthCoordinator
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    var body: some View {
        // Similar structure to SignInCoordinatedView but for sign up
        VStack {
            Text("Sign Up View")
            // Add your sign up form here
            
            Button("Sign Up") {
                coordinator.signUp(name: name, email: email, password: password, confirmPassword: confirmPassword)
            }
            
            Button("Back to Sign In") {
                coordinator.navigateTo(.signIn)
            }
        }
    }
}

struct ForgotPasswordCoordinatedView: View {
    @EnvironmentObject var coordinator: AuthCoordinator
    @State private var email: String = ""
    
    var body: some View {
        VStack {
            Text("Forgot Password View")
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("Reset Password") {
                coordinator.resetPassword(email: email)
            }
            
            Button("Back to Sign In") {
                coordinator.navigateTo(.signIn)
            }
        }
        .padding()
    }
}
