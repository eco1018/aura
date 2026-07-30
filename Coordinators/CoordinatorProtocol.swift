//
//  CoordinatorProtocol.swift
//  aura
//
//
// CoordinatorProtocol.swift
// aura
//
// STEP 1: Just add this ONE file
// Changes NOTHING in your existing app
// This is just the foundation we'll build on
//

import SwiftUI

// MARK: - Basic Coordinator Protocol
protocol Coordinator: ObservableObject {
    func start()
    func navigate(to destination: String)
    func goBack()
}

// MARK: - Simple Navigation State
class NavigationState: ObservableObject {
    @Published var currentScreen: String = ""
    @Published var navigationStack: [String] = []
    
    func pushScreen(_ screen: String) {
        navigationStack.append(screen)
        currentScreen = screen
        print("📱 Pushed: \(screen)")
    }
    
    func popScreen() {
        if !navigationStack.isEmpty {
            navigationStack.removeLast()
            currentScreen = navigationStack.last ?? ""
            print("📱 Popped to: \(currentScreen)")
        }
    }
    
    func clearStack() {
        navigationStack.removeAll()
        currentScreen = ""
        print("📱 Cleared navigation stack")
    }
}
