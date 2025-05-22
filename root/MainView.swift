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
            VStack(spacing: 32) {
                // Header with user greeting
                VStack(spacing: 8) {
                    Text("Hello, \(authVM.userProfile?.name ?? "Friend")")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("How are you feeling today?")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 40)
                
                Spacer()
                
                // Main action buttons
                VStack(spacing: 20) {
                    // Daily Diary Card button
                    Button(action: {
                        showingDiaryCard = true
                    }) {
                        HStack {
                            Image(systemName: "heart.text.square.fill")
                                .font(.title2)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Daily Diary Card")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                
                                Text("Track your emotions and skills")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.title3)
                                .foregroundColor(.secondary)
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.blue.opacity(0.1))
                                .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    // Settings button
                    Button(action: {
                        showingSettings = true
                    }) {
                        HStack {
                            Image(systemName: "gearshape.fill")
                                .font(.title2)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Settings")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                
                                Text("Manage your preferences")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.title3)
                                .foregroundColor(.secondary)
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.gray.opacity(0.1))
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Today's date
                Text("Today is \(Date(), style: .date)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 40)
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
