//
//  DiaryHistoryView.swift
//  aura
//
//  Created by Ella A. Sadduq on 5/22/25.
//


//
//  DiaryHistoryView.swift
//  aura
//
//  Created by Assistant on 5/22/25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct DiaryHistoryView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var diaryEntries: [DiaryEntry] = []
    @State private var isLoading = true
    @State private var selectedEntry: DiaryEntry?
    @State private var showingEntryDetail = false
    
    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Loading your diary history...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if diaryEntries.isEmpty {
                    emptyStateView
                } else {
                    diaryEntriesList
                }
            }
            .navigationTitle("Diary History")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            loadDiaryEntries()
        }
        .sheet(isPresented: $showingEntryDetail) {
            if let entry = selectedEntry {
                DiaryEntryDetailView(entry: entry)
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart.text.square")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No Diary Entries Yet")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Start filling out your daily diary cards to see your progress here.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var diaryEntriesList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(diaryEntries.sorted(by: { $0.timestamp > $1.timestamp })) { entry in
                    DiaryEntryCard(entry: entry) {
                        selectedEntry = entry
                        showingEntryDetail = true
                    }
                }
            }
            .padding()
        }
    }
    
    private func loadDiaryEntries() {
        guard let userId = Auth.auth().currentUser?.uid else {
            isLoading = false
            return
        }
        
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(userId)
            .collection("diaryEntries")
            .order(by: "timestamp", descending: true)
            .limit(to: 50) // Limit to last 50 entries
            .getDocuments { snapshot, error in
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    if let error = error {
                        print("❌ Error fetching diary entries: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let documents = snapshot?.documents else {
                        print("⚠️ No diary entries found")
                        return
                    }
                    
                    self.diaryEntries = documents.compactMap { document in
                        try? document.data(as: DiaryEntry.self)
                    }
                    
                    print("✅ Loaded \(self.diaryEntries.count) diary entries")
                }
            }
    }
}

struct DiaryEntryCard: View {
    let entry: DiaryEntry
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(entry.timestamp.formatted(date: .abbreviated, time: .omitted))
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text("\(entry.session.displayName) • \(entry.timestamp.formatted(date: .omitted, time: .shortened))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // Quick Summary
                HStack(spacing: 16) {
                    // Emotions Summary
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Emotions")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text(topEmotions)
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    
                    Spacer()
                    
                    // Goals Progress
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("Goals")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("\(completedGoalsCount)/\(totalGoalsCount)")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(completedGoalsCount > 0 ? .green : .orange)
                    }
                }
                
                // Note Preview (if exists)
                if !entry.dailyNote.note.isEmpty {
                    Text("\"\(entry.dailyNote.note.prefix(80))\(entry.dailyNote.note.count > 80 ? "..." : "")\"")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .italic()
                        .lineLimit(2)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var topEmotions: String {
        let emotions = entry.emotions.emotions
            .filter { $0.value.value > 5 }
            .sorted { $0.value.value > $1.value.value }
            .prefix(2)
            .map { $0.key }
        
        return emotions.isEmpty ? "Balanced" : emotions.joined(separator: ", ")
    }
    
    private var completedGoalsCount: Int {
        entry.goals.goals.values.filter { $0 }.count
    }
    
    private var totalGoalsCount: Int {
        entry.goals.goals.count
    }
}

#Preview {
    DiaryHistoryView()
}