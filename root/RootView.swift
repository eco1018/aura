//
//
// RootView.swift

// RootView.swift
// aura
//
// Created by Ella A. Sadduq on 3/27/25.
//

// RootView.swift

//
//  RootView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/27/25.
//

//
//  RootView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/27/25.
//

//
//  RootView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/27/25.
//

import SwiftUI

struct RootView: View {
    @StateObject private var authVM = AuthViewModel.shared
    
    var body: some View {
        Group {
            switch authVM.authFlow {
            case .signIn:
                SignInView()
            case .signUp:
                SignUpView()
            case .forgotPassword:
                ForgotPasswordView()
            case .main:
                MainView() // Your app’s main content
            }
        }
        .environmentObject(authVM)
    }
}
