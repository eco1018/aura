//
//
//  MainView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/27/25.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var showingDiaryCard = false
    @State private var showingSettings = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Premium gradient background
                LinearGradient(
                    colors: [
                        Color(.systemGray6).opacity(0.1),
                        Color(.systemGray5).opacity(0.2),
                        Color(.systemGray6).opacity(0.15)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 60) {
                    // Elegant header
                    VStack(spacing: 20) {
                        Text("Hello, \(authVM.userProfile?.name ?? "Friend")")
                            .font(.system(size: 34, weight: .light, design: .default))
                            .foregroundColor(.primary.opacity(0.9))
                        
                        Text("How are you feeling today?")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.secondary.opacity(0.7))
                    }
                    .padding(.top, 80)
                    
                    Spacer()
                    
                    // Glassmorphic cards
                    VStack(spacing: 24) {
                        // Daily Diary Card - Premium glass effect
                        Button(action: {
                            showingDiaryCard = true
                        }) {
                            HStack(spacing: 20) {
                                // Elegant 3D icon
                                Image(systemName: "heart.text.square")
                                    .font(.system(size: 28, weight: .light))
                                    .foregroundColor(.primary.opacity(0.8))
                                    .shadow(color: .primary.opacity(0.1), radius: 2, x: 1, y: 1)
                                    .shadow(color: .white.opacity(0.8), radius: 1, x: -0.5, y: -0.5)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Daily Diary Card")
                                        .font(.system(size: 19, weight: .medium))
                                        .foregroundColor(.primary.opacity(0.9))
                                    
                                    Text("Track your emotions and skills")
                                        .font(.system(size: 15, weight: .regular))
                                        .foregroundColor(.secondary.opacity(0.6))
                                }
                                
                                Spacer()
                                
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.secondary.opacity(0.4))
                            }
                            .padding(28)
                            .background(
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(Color(.systemBackground).opacity(0.8))
                                    .background(
                                        RoundedRectangle(cornerRadius: 24)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                                    .shadow(color: .black.opacity(0.04), radius: 20, x: 0, y: 8)
                                    .shadow(color: .black.opacity(0.02), radius: 1, x: 0, y: 1)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        // Settings Card - Matching glass effect
                        Button(action: {
                            showingSettings = true
                        }) {
                            HStack(spacing: 20) {
                                // Elegant 3D icon
                                Image(systemName: "gearshape")
                                    .font(.system(size: 28, weight: .light))
                                    .foregroundColor(.primary.opacity(0.8))
                                    .shadow(color: .primary.opacity(0.1), radius: 2, x: 1, y: 1)
                                    .shadow(color: .white.opacity(0.8), radius: 1, x: -0.5, y: -0.5)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Settings")
                                        .font(.system(size: 19, weight: .medium))
                                        .foregroundColor(.primary.opacity(0.9))
                                    
                                    Text("Manage your preferences")
                                        .font(.system(size: 15, weight: .regular))
                                        .foregroundColor(.secondary.opacity(0.6))
                                }
                                
                                Spacer()
                                
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.secondary.opacity(0.4))
                            }
                            .padding(28)
                            .background(
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(Color(.systemBackground).opacity(0.8))
                                    .background(
                                        RoundedRectangle(cornerRadius: 24)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                                    .shadow(color: .black.opacity(0.04), radius: 20, x: 0, y: 8)
                                    .shadow(color: .black.opacity(0.02), radius: 1, x: 0, y: 1)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal, 28)
                    
                    Spacer()
                    
                    // Minimal date
                    Text("Today is \(Date(), style: .date)")
                        .font(.system(size: 14, weight: .light))
                        .foregroundColor(.secondary.opacity(0.5))
                        .padding(.bottom, 60)
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingDiaryCard) {
            DiaryCardFlowView(session: determineSession())
        }
        .sheet(isPresented: $showingSettings) {
            EnhancedSettingsView()
                .environmentObject(authVM)
        }
    }
    
    // MARK: - Helper Methods
    private func determineSession() -> DiarySession {
        let hour = Calendar.current.component(.hour, from: Date())
        
        // Morning: 5 AM - 12 PM
        if hour >= 5 && hour < 12 {
            return .morning
        }
        // Evening: 6 PM - 11 PM
        else if hour >= 18 && hour < 23 {
            return .evening
        }
        // Manual: All other times
        else {
            return .manual
        }
    }
}

#Preview {
    MainView()
        .environmentObject(AuthViewModel.shared)
}
