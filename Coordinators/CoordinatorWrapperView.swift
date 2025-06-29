//
//  CoordinatorWrapperView.swift
//  aura
//
//
//
// CoordinatorWrapperView.swift
// aura
//
// STEP 6: Replace auth placeholder with real views
// Keep onboarding and main as placeholders for now
//

import SwiftUI

struct CoordinatorWrapperView: View {
    @EnvironmentObject var appCoordinator: AppCoordinator
    @EnvironmentObject var authVM: AuthViewModel
    
    // 🎛️ Set this to true to test the coordinator navigation
    // Set to false to use your existing navigation
    @State private var useCoordinatorNavigation = false
    
    var body: some View {
        Group {
            if useCoordinatorNavigation {
                // 🆕 NEW: Coordinator controls navigation
                coordinatorControlledView
            } else {
                // 📝 EXISTING: Your current navigation (unchanged)
                RootView()
            }
        }
        .onAppear {
            if useCoordinatorNavigation {
                print("🎛️ Using COORDINATOR navigation")
            } else {
                print("🎛️ Using EXISTING navigation")
            }
        }
    }
    
    @ViewBuilder
    private var coordinatorControlledView: some View {
        Group {
            if !authVM.isAuthenticated {
                // 🆕 REAL: Use actual auth views instead of placeholder
                authFlowView
            } else if !OnboardingViewModel.shared.hasCompletedOnboarding {
                // 🆕 REAL: Use actual onboarding view
                OnboardingFlowView()
                    .environmentObject(OnboardingViewModel.shared)
                    .onAppear {
                        print("📱 Coordinator: Showing OnboardingFlowView")
                    }
            } else {
                // 🆕 REAL: Use actual main view
                MainView()
                    .environmentObject(authVM)
                    .onAppear {
                        print("📱 Coordinator: Showing MainView")
                    }
            }
        }
    }
    
    // MARK: - Real Auth Flow Views
    @ViewBuilder
    private var authFlowView: some View {
        Group {
            switch authVM.authFlow {
            case .signIn:
                SignInView()
                    .environmentObject(authVM)
                    .onAppear {
                        print("📱 Coordinator: Showing SignInView")
                    }
            case .signUp:
                SignUpView()
                    .environmentObject(authVM)
                    .onAppear {
                        print("📱 Coordinator: Showing SignUpView")
                    }
            case .forgotPassword:
                ForgotPasswordView()
                    .environmentObject(authVM)
                    .onAppear {
                        print("📱 Coordinator: Showing ForgotPasswordView")
                    }
            }
        }
    }
}

// MARK: - Debug Helper (Optional)
struct CoordinatorTestButton: View {
    @Binding var useCoordinator: Bool
    
    var body: some View {
        VStack {
            Button("Toggle Navigation Mode") {
                useCoordinator.toggle()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            Text(useCoordinator ? "Using Coordinator" : "Using RootView")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}
