//
// MARK: - Views/MainView.swift
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
            DiaryCardView()
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
    }
}

// MARK: - Views/DiaryCardView.swift (Updated to be presentable)
struct DiaryCardView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selfHarmUrges: Double = 0
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Daily Diary Card")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text(Date(), style: .date)
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top)
                    
                    // First rating section - Self-harm urges
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Actions")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        RatingCardView(
                            title: "Self-harm urges",
                            description: "Rate the intensity of self-harm urges today",
                            value: $selfHarmUrges
                        )
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        // TODO: Save functionality
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

// MARK: - Views/SettingsView.swift (Basic placeholder)
struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Settings")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                
                Spacer()
                
                // Sign out button
                Button(action: {
                    authVM.signOut()
                    dismiss()
                }) {
                    Text("Sign Out")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Components/RatingCardView.swift (Same as before)
struct RatingCardView: View {
    let title: String
    let description: String
    @Binding var value: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.medium)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            VStack(spacing: 8) {
                // Rating slider
                HStack {
                    Text("0")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Slider(value: $value, in: 0...10, step: 1)
                        .tint(.blue)
                    
                    Text("10")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // Current value display
                Text("Current rating: \(Int(value))")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
}

// MARK: - Preview
#Preview {
    MainView()
        .environmentObject(AuthViewModel.shared)
}
