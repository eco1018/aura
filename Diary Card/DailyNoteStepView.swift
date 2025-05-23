//
//  DailyNoteStepView.swift
//  DailyNoteStepView.swift
//  aura
//
//  Created by Ella A. Sadduq on 5/22/25.
//

import SwiftUI

struct DailyNoteStepView: View {
    @ObservedObject var diaryEntry: DiaryEntryViewModel
    @State private var dailyNote: String = ""
    @FocusState private var isNoteFieldFocused: Bool
    
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
                
                Text("Today")
                    .font(.subheadline)
                    .foregroundColor(.orange)
            }
            .padding(.top, 60)
            .padding(.bottom, 40)
            
            // Main text input area
            ScrollView {
                VStack {
                    TextField("What happened today?", text: $dailyNote, axis: .vertical)
                        .font(.body)
                        .foregroundColor(.primary)
                        .textFieldStyle(PlainTextFieldStyle())
                        .lineLimit(1...50)
                        .focused($isNoteFieldFocused)
                        .onChange(of: dailyNote) { _, newValue in
                            diaryEntry.updateDailyNote(note: newValue)
                        }
                    
                    Spacer(minLength: 300)
                }
                .padding(.horizontal, 30)
            }
            
            Spacer()
        }
        .background(Color(.systemBackground))
        .onAppear {
            // Load existing values if any - combining all fields into one
            let existingNote = diaryEntry.getDailyNote()
            let existingMood = diaryEntry.getDailyMood()
            let existingHighlights = diaryEntry.getDailyHighlights()
            
            // Combine all existing content into the single text field
            var combinedText = ""
            if !existingNote.isEmpty { combinedText += existingNote }
            if !existingMood.isEmpty {
                if !combinedText.isEmpty { combinedText += "\n\n" }
                combinedText += "Mood: \(existingMood)"
            }
            if !existingHighlights.isEmpty {
                if !combinedText.isEmpty { combinedText += "\n\n" }
                combinedText += "Highlights: \(existingHighlights)"
            }
            
            dailyNote = combinedText
        }
        .onTapGesture {
            // Dismiss keyboard when tapping outside
            isNoteFieldFocused = false
        }
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
