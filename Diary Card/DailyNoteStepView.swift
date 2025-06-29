//
//  DailyNoteStepView.swift
//  DailyNoteStepView.swift
//  aura
//
//  Enhanced DailyNoteStepView.swift
//  aura
//
//  Enhanced with proper data binding and validation

//
//  DailyNoteStepView.swift
//  aura
//
//  Created by Ella A. Sadduq on 5/22/25.
//

import SwiftUI

struct DailyNoteStepView: View {
    @ObservedObject var diaryEntry: DiaryEntryViewModel
    @State private var dailyNote: String = ""
    @State private var dailyMood: String = ""
    @State private var dailyHighlights: String = ""
    @FocusState private var isNoteFieldFocused: Bool
    @FocusState private var isMoodFieldFocused: Bool
    @FocusState private var isHighlightsFieldFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Clean header with date
            VStack(spacing: 8) {
                Text(getCurrentDateString())
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(getCurrentDayString())
                    .font(.title)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Text("Daily Reflection")
                    .font(.subheadline)
                    .foregroundColor(.orange)
            }
            .padding(.top, 60)
            .padding(.bottom, 40)
            
            // Main text input areas
            ScrollView {
                VStack(spacing: 24) {
                    // Daily Note Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("What happened today?")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        TextField("Share your thoughts about today...", text: $dailyNote, axis: .vertical)
                            .font(.body)
                            .foregroundColor(.primary)
                            .textFieldStyle(PlainTextFieldStyle())
                            .lineLimit(5...15)
                            .focused($isNoteFieldFocused)
                            .onChange(of: dailyNote) { _, newValue in
                                diaryEntry.updateDailyNote(note: newValue)
                                print("📝 Daily note updated: '\(newValue.prefix(50))...'")
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemGray6))
                            )
                    }
                    
                    // Daily Mood Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("How would you describe your overall mood today?")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        TextField("Describe your mood...", text: $dailyMood, axis: .vertical)
                            .font(.body)
                            .foregroundColor(.primary)
                            .textFieldStyle(PlainTextFieldStyle())
                            .lineLimit(2...5)
                            .focused($isMoodFieldFocused)
                            .onChange(of: dailyMood) { _, newValue in
                                diaryEntry.updateDailyNote(mood: newValue)
                                print("📝 Daily mood updated: '\(newValue)'")
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemGray6))
                            )
                    }
                    
                    // Daily Highlights Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("What were the highlights of your day?")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        TextField("Share some positive moments...", text: $dailyHighlights, axis: .vertical)
                            .font(.body)
                            .foregroundColor(.primary)
                            .textFieldStyle(PlainTextFieldStyle())
                            .lineLimit(3...8)
                            .focused($isHighlightsFieldFocused)
                            .onChange(of: dailyHighlights) { _, newValue in
                                diaryEntry.updateDailyNote(highlights: newValue)
                                print("📝 Daily highlights updated: '\(newValue.prefix(50))...'")
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemGray6))
                            )
                    }
                    
                    Spacer(minLength: 200)
                }
                .padding(.horizontal, 30)
            }
            
            Spacer()
        }
        .background(Color(.systemBackground))
        .onAppear {
            loadExistingData()
            print("📱 DailyNoteStepView appeared")
            print("   - Existing note: '\(diaryEntry.getDailyNote().prefix(50))...'")
            print("   - Existing mood: '\(diaryEntry.getDailyMood())'")
            print("   - Existing highlights: '\(diaryEntry.getDailyHighlights().prefix(50))...'")
        }
        .onTapGesture {
            // Dismiss keyboard when tapping outside
            isNoteFieldFocused = false
            isMoodFieldFocused = false
            isHighlightsFieldFocused = false
        }
    }
    
    private func loadExistingData() {
        // Load existing values from the diary entry
        dailyNote = diaryEntry.getDailyNote()
        dailyMood = diaryEntry.getDailyMood()
        dailyHighlights = diaryEntry.getDailyHighlights()
        
        print("📤 Loaded existing daily note data:")
        print("   - Note length: \(dailyNote.count)")
        print("   - Mood length: \(dailyMood.count)")
        print("   - Highlights length: \(dailyHighlights.count)")
    }
    
    private func getCurrentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: Date())
    }
    
    private func getCurrentDayString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: Date())
    }
}

#Preview {
    DailyNoteStepView(diaryEntry: DiaryEntryViewModel(session: .manual))
}
