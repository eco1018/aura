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
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var authSettings: AuthSettings

    var body: some View {
        Group {
            if authVM.user == nil {
                SignInView()
            } else {
                MainView()
            }
        }
        .onAppear {
            print("🌀 RootView appeared — authVM.user = \(authVM.user?.email ?? "nil")")
        }
    }
}
