//
//  auraApp.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/27/25.
//

//
// 
//
//  AuraApp.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/27/25.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct AuraApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @StateObject private var authVM = AuthViewModel.shared
    @StateObject private var authSettings = AuthSettings()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authVM)
                .environmentObject(authSettings)
        }
    }
}
