//
//
//  AuthCoordinator.swift
//  aura
//
//  Auth Coordinator for managing authentication flow

import SwiftUI
import FirebaseAuth
import Combine

// MARK: - Auth Loading View
struct AuthLoadingView: View {
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 16) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .black))
                    .scaleEffect(1.2)
                
                Text("Loading...")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.black.opacity(0.7))
            }
        }
    }
}

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
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    
    // MARK: - Dependencies
    let authViewModel: AuthViewModel
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Computed Properties
    var isLoading: Bool { authViewModel.isLoading }
    
    // MARK: - Initialization
    init(authViewModel: AuthViewModel = AuthViewModel.shared) {
        self.authViewModel = authViewModel
        observeAuthViewModel()
        determineInitialView()
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
        
        clearError()
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
        
        clearError()
        authViewModel.signUp(name: name, email: email, password: password)
    }
    
    func resetPassword(email: String) {
        guard !email.isEmpty else {
            showErrorMessage("Please enter your email address")
            return
        }
        
        clearError()
        authViewModel.resetPassword(email: email)
        
        // Show success message and navigate back
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.showSuccessMessage("Password reset email sent")
            self.navigateTo(.signIn)
        }
    }
    
    // MARK: - Private Methods
    private func observeAuthViewModel() {
        // Observe authentication state changes
        authViewModel.$isAuthenticated
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isAuthenticated in
                guard let self = self else { return }
                
                if isAuthenticated {
                    print("✅ AuthCoordinator: User authenticated")
                    self.handleAuthSuccess()
                } else {
                    print("❌ AuthCoordinator: User not authenticated")
                    if self.currentView == .authenticated {
                        self.reset()
                    }
                }
            }
            .store(in: &cancellables)
        
        // Observe auth errors from AuthViewModel
        authViewModel.$authError
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                self?.showErrorMessage(errorMessage)
            }
            .store(in: &cancellables)
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
    }
    
    private func showSuccessMessage(_ message: String) {
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
                AuthLoadingView()
                
            case .signIn:
                SignInCoordinatedView()
                    .environmentObject(coordinator)
                
            case .signUp:
                SignUpCoordinatedView()
                    .environmentObject(coordinator)
                
            case .forgotPassword:
                ForgotPasswordCoordinatedView()
                    .environmentObject(coordinator)
                
            case .authenticated:
                // This transitions to main app flow via RootView
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
                Color.white.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        Spacer(minLength: 100)
                        
                        headerSection
                        formSection
                        actionSection
                        
                        Spacer(minLength: 50)
                    }
                }
                
                // Loading overlay
                if coordinator.isLoading {
                    loadingOverlay
                }
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 24) {
            Text("Welcome Back")
                .font(.system(size: 32, weight: .light))
                .foregroundColor(.black)
                .tracking(1.2)
            
            Text("Sign in to continue your journey")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.black.opacity(0.6))
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
                
                TextField("Enter your email", text: $email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
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
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isEmailFocused = true
                        }
                    }
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
                            .foregroundColor(.black.opacity(0.6))
                        
                        Text("Sign Up")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.black)
                    }
                    .tracking(0.2)
                }
            }
        }
        .padding(.horizontal, 40)
    }
    
    private var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.2)
                
                Text("Signing you in...")
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

// MARK: - Coordinated Sign Up View
struct SignUpCoordinatedView: View {
    @EnvironmentObject var coordinator: AuthCoordinator
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    var body: some View {
        VStack(spacing: 32) {
            Text("Create Account")
                .font(.system(size: 32, weight: .light))
                .foregroundColor(.black)
            
            VStack(spacing: 20) {
                TextField("Full Name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                SecureField("Confirm Password", text: $confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            Button("Sign Up") {
                coordinator.signUp(name: name, email: email, password: password, confirmPassword: confirmPassword)
            }
            .buttonStyle(.borderedProminent)
            .disabled(coordinator.isLoading)
            
            Button("Back to Sign In") {
                coordinator.navigateTo(.signIn)
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}

// MARK: - Coordinated Forgot Password View
struct ForgotPasswordCoordinatedView: View {
    @EnvironmentObject var coordinator: AuthCoordinator
    @State private var email: String = ""
    
    var body: some View {
        VStack(spacing: 32) {
            Text("Reset Password")
                .font(.system(size: 32, weight: .light))
                .foregroundColor(.black)
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            
            Button("Send Reset Email") {
                coordinator.resetPassword(email: email)
            }
            .buttonStyle(.borderedProminent)
            .disabled(coordinator.isLoading)
            
            Button("Back to Sign In") {
                coordinator.navigateTo(.signIn)
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}
