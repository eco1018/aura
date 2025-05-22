//
//  DiaryEntryDetailView.swift
//  aura
//
//  Created by Ella A. Sadduq on 5/22/25.
//


//
//  DiaryEntryDetailView.swift
//  aura
//
//  Created by Assistant on 5/22/25.
//

import SwiftUI

struct DiaryEntryDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let entry: DiaryEntry
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    headerSection
                    
                    // Sections
                    VStack(spacing: 20) {
                        if hasActions {
                            actionsSection
                        }
                        
                        if hasUrges {
                            urgesSection
                        }
                        
                        if hasEmotions {
                            emotionsSection
                        }
                        
                        skillsSection
                        
                        medicationsSection
                        
                        if hasGoals {
                            goalsSection
                        }
                        
                        if hasDailyNote {
                            dailyNoteSection
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Diary Entry")
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
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 8) {
            Text(entry.timestamp.formatted(date: .complete, time: .omitted))
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("\(entry.session.displayName) • \(entry.timestamp.formatted(date: .omitted, time: .shortened))")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
    
    // MARK: - Actions Section
    private var hasActions: Bool {
        entry.actions.selfHarm.value > 0 || 
        entry.actions.suicide.value > 0 || 
        !entry.actions.customActions.isEmpty
    }
    
    private var actionsSection: some View {
        DetailSection(
            title: "Actions",
            icon: "exclamationmark.triangle",
            iconColor: .orange
        ) {
            VStack(spacing: 8) {
                if entry.actions.selfHarm.value > 0 {
                    DetailRow(label: "Self-harm", value: "\(entry.actions.selfHarm.value)/10")
                }
                
                if entry.actions.suicide.value > 0 {
                    DetailRow(label: "Suicide", value: "\(entry.actions.suicide.value)/10")
                }
                
                ForEach(Array(entry.actions.customActions.keys.sorted()), id: \.self) { key in
                    if let rating = entry.actions.customActions[key], rating.value > 0 {
                        DetailRow(label: key, value: "\(rating.value)/10")
                    }
                }
            }
        }
    }
    
    // MARK: - Urges Section
    private var hasUrges: Bool {
        entry.urges.selfHarmUrge.value > 0 ||
        entry.urges.suicideUrge.value > 0 ||
        entry.urges.quitTherapyUrge.value > 0 ||
        !entry.urges.customUrges.isEmpty
    }
    
    private var urgesSection: some View {
        DetailSection(
            title: "Urges",
            icon: "flame",
            iconColor: .red
        ) {
            VStack(spacing: 8) {
                DetailRow(label: "Self-harm urge", value: "\(entry.urges.selfHarmUrge.value)/10")
                DetailRow(label: "Suicide urge", value: "\(entry.urges.suicideUrge.value)/10")
                DetailRow(label: "Quit therapy urge", value: "\(entry.urges.quitTherapyUrge.value)/10")
                
                ForEach(Array(entry.urges.customUrges.keys.sorted()), id: \.self) { key in
                    if let rating = entry.urges.customUrges[key] {
                        DetailRow(label: key, value: "\(rating.value)/10")
                    }
                }
            }
        }
    }
    
    // MARK: - Emotions Section
    private var hasEmotions: Bool {
        !entry.emotions.emotions.isEmpty
    }
    
    private var emotionsSection: some View {
        DetailSection(
            title: "Emotions",
            icon: "heart",
            iconColor: .pink
        ) {
            VStack(spacing: 8) {
                ForEach(Array(entry.emotions.emotions.keys.sorted()), id: \.self) { emotion in
                    if let rating = entry.emotions.emotions[emotion] {
                        DetailRow(label: emotion, value: "\(rating.value)/10")
                    }
                }
            }
        }
    }
    
    // MARK: - Skills Section
    private var skillsSection: some View {
        DetailSection(
            title: "Skills Effectiveness",
            icon: "brain.head.profile",
            iconColor: .blue
        ) {
            DetailRow(label: "Overall effectiveness", value: "\(entry.skills.effectiveness)/10")
        }
    }
    
    // MARK: - Medications Section
    private var medicationsSection: some View {
        DetailSection(
            title: "Medications",
            icon: "pills",
            iconColor: .green
        ) {
            VStack(spacing: 8) {
                DetailRow(
                    label: "Took medication",
                    value: entry.medications.tookMedication ? "Yes" : "No"
                )
                
                if !entry.medications.notes.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Notes:")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text(entry.medications.notes)
                            .font(.body)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 4)
                }
            }
        }
    }
    
    // MARK: - Goals Section
    private var hasGoals: Bool {
        !entry.goals.goals.isEmpty
    }
    
    private var goalsSection: some View {
        DetailSection(
            title: "Goals",
            icon: "target",
            iconColor: .purple
        ) {
            VStack(spacing: 8) {
                ForEach(Array(entry.goals.goals.keys.sorted()), id: \.self) { goal in
                    if let completed = entry.goals.goals[goal] {
                        DetailRow(
                            label: goal,
                            value: completed ? "✓ Completed" : "○ Not completed"
                        )
                    }
                }
            }
        }
    }
    
    // MARK: - Daily Note Section
    private var hasDailyNote: Bool {
        !entry.dailyNote.note.isEmpty || 
        !entry.dailyNote.mood.isEmpty || 
        !entry.dailyNote.highlights.isEmpty
    }
    
    private var dailyNoteSection: some View {
        DetailSection(
            title: "Daily Reflection",
            icon: "note.text",
            iconColor: .indigo
        ) {
            VStack(alignment: .leading, spacing: 12) {
                if !entry.dailyNote.mood.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Overall Mood:")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(entry.dailyNote.mood)
                            .font(.body)
                    }
                }
                
                if !entry.dailyNote.highlights.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Highlights:")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(entry.dailyNote.highlights)
                            .font(.body)
                    }
                }
                
                if !entry.dailyNote.note.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Daily Note:")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(entry.dailyNote.note)
                            .font(.body)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

// MARK: - Helper Views
struct DetailSection<Content: View>: View {
    let title: String
    let icon: String
    let iconColor: Color
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(iconColor)
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
            }
            
            content
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
}

struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.body)
            
            Spacer()
            
            Text(value)
                .font(.body)
                .fontWeight(.medium)
        }
    }
}

#Preview {
    // Create a sample entry for preview
    let sampleEntry = DiaryEntry(
        userId: "sample",
        session: .evening,
        userProfile: nil
    )
    
    DiaryEntryDetailView(entry: sampleEntry)
}