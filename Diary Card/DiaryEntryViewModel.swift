//
//  DiaryEntryViewModel.swift
//  aura
//
//  Created by Ella A. Sadduq on 5/22/25.
//


//
//  DiaryEntryViewModel.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/28/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class DiaryEntryViewModel: ObservableObject {
    @Published var diaryEntry: DiaryEntry
    @Published var isLoading: Bool = false
    @Published var saveMessage: String = ""
    
    private let db = Firestore.firestore()
    
    init(session: DiarySession) {
        // Get current user ID from Auth
        let userId = Auth.auth().currentUser?.uid ?? "anonymous"
        self.diaryEntry = DiaryEntry(userId: userId, session: session)
    }
    
    // MARK: - Action Updates
    func updateActionRating(_ action: String, value: Int) {
        switch action {
        case "selfHarmUrges":
            diaryEntry.actions.selfHarmUrges = IntensityRating(value: value)
        case "suicidalThoughts":
            diaryEntry.actions.suicidalThoughts = IntensityRating(value: value)
        default:
            break
            // TODO: Handle custom actions later
        }
    }
    
    // MARK: - Save Entry
    func saveEntry(completion: @escaping (Bool) -> Void) {
        isLoading = true
        
        do {
            try db.collection("users")
                .document(diaryEntry.userId)
                .collection("diaryEntries")
                .addDocument(from: diaryEntry) { [weak self] error in
                    DispatchQueue.main.async {
                        self?.isLoading = false
                        
                        if let error = error {
                            print("❌ Failed to save diary entry: \(error.localizedDescription)")
                            self?.saveMessage = "Failed to save entry"
                            completion(false)
                        } else {
                            print("✅ Diary entry saved successfully")
                            self?.saveMessage = "Entry saved successfully!"
                            completion(true)
                        }
                    }
                }
        } catch {
            DispatchQueue.main.async {
                self.isLoading = false
                self.saveMessage = "Failed to save entry"
                completion(false)
            }
        }
    }
}