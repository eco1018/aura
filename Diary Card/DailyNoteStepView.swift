//
//  DailyNoteStepView.swift
//  aura
//
//  Created by Ella A. Sadduq on 5/22/25.
//


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
    @State private var mood: String = ""
    @State private var highlights: String = ""
    @FocusState private var isNoteFieldFocused: Bool
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header section
                VStack(spacing: 8) {
                    Image(systemName: DiaryStep.dailyNote.systemImage)
                        .font(.largeTitle)
                        .foregroundColor(.purple)
                    
                    Text(DiaryStep.dailyNote.title)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(DiaryStep.dailyNote.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top)
                
                // Main reflection section
                VStack(spacing: 20) {
                    // Daily reflection
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Daily Reflection")
                                .font(.headline)
                                .fontWeight(.medium)
                            
                            Spacer()
                            
                            Text("Optional")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(Color(.systemGray5))
                                .cornerRadius(4)
                        }
                        
                        Text("How was your day? What thoughts or feelings do you want to capture?")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        TextField("Write about your day, any insights, challenges, victories, or whatever feels important to remember...", text: $dailyNote, axis: .vertical)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .lineLimit(4...8)
                            .focused($isNoteFieldFocused)
                            .onChange(of: dailyNote) { _, newValue in
                                diaryEntry.updateDailyNote(note: newValue)
                            }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemGray6))
                    )
                    
                    // Mood summary
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Overall Mood")
                            .font(.headline)
                            .fontWeight(.medium)
                        
                        Text("Sum up your mood in a word or short phrase")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        TextField("Peaceful, overwhelmed, hopeful, mixed, etc.", text: $mood)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onChange(of: mood) { _, newValue in
                                diaryEntry.updateDailyNote(mood: newValue)
                            }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemGray6))
                    )
                    
                    // Highlights
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Today's Highlights")
                            .font(.headline)
                            .fontWeight(.medium)
                        
                        Text("What went well today? Any positive moments, no matter how small?")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        TextField("Small wins, moments of joy, things you're grateful for...", text: $highlights, axis: .vertical)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .lineLimit(2...4)
                            .onChange(of: highlights) { _, newValue in
                                diaryEntry.updateDailyNote(highlights: newValue)
                            }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.green.opacity(0.05))
                            .stroke(Color.green.opacity(0.2), lineWidth: 1)
                    )
                }
                
                // Encouraging prompts
                VStack(spacing: 12) {
                    Text("Reflection Prompts")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                        ForEach(reflectionPrompts, id: \.self) { prompt in
                            Button(action: {
                                if dailyNote.isEmpty {
                                    dailyNote = prompt
                                } else {
                                    dailyNote += "\n\n" + prompt
                                }
                                isNoteFieldFocused = true
                                diaryEntry.updateDailyNote(note: dailyNote)
                            }) {
                                Text(prompt)
                                    .font(.caption)
                                    .foregroundColor(.blue)
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.blue.opacity(0.1))
                                            .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                                    )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer(minLength: 100)
            }
            .padding()
        }
        .onAppear {
            // Load existing values if any
            dailyNote = diaryEntry.getDailyNote()
            mood = diaryEntry.getDailyMood()
            highlights = diaryEntry.getDailyHighlights()
        }
        .onTapGesture {
            // Dismiss keyboard when tapping outside
            isNoteFieldFocused = false
        }
    }
    
    private var reflectionPrompts: [String] {
        [
            "What did I learn about myself today?",
            "How did I use my DBT skills?",
            "What challenged me most?",
            "What am I grateful for?",
            "How did I show self-compassion?",
            "What would I tell a friend about today?",
            "What emotion surprised me?",
            "How did I connect with others?"
        ]
    }
}

#Preview {
    DailyNoteStepView(diaryEntry: DiaryEntryViewModel(session: .manual))
}