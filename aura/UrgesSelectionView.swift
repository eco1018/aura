

//
//  UrgesSelectionView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/29/25.
//

import SwiftUI

struct UrgesSelectionView: View {
    @State private var selectedUrges = Set<String>()
    @State private var customUrge1: String = ""
    @State private var customUrge2: String = ""

    let urges = [
        ("Substance Use", "The desire to use drugs or alcohol to cope with pain."),
        ("Disordered Eating", "The urge to restrict, binge, or purge food."),
        ("Shutting Down", "An urge to shut down emotionally and avoid interaction."),
        ("Breaking Things", "The urge to destroy things when frustrated."),
        ("Impulsive Sex", "A desire to engage in sexual behavior impulsively."),
        ("Impulsive Spending", "The urge to spend money recklessly."),
        ("Ending Relationships", "An urge to break up or end relationships impulsively."),
        ("Dropping Out", "The urge to quit or give up on commitments or responsibilities."),
        ("Other", "Something else you want to track — write it in.")
    ]
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            // MARK: - Title
            Text("Choose 2 Urges to Track")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            // MARK: - Urges List
            List(urges, id: \.0) { urge in
                HStack {
                    Text(urge.0)
                        .font(.body)
                        .fontWeight(.semibold)
                        .padding(.trailing, 8)
                    Spacer()
                    Text(urge.1)
                        .font(.body)
                        .foregroundColor(.gray)
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)

                    if urge.0 == "Other" {
                        TextField("Describe your urge", text: $customUrge1)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.trailing)
                            .padding(.vertical, 8) // Add more vertical space for custom input
                    } else {
                        Button(action: {
                            if selectedUrges.contains(urge.0) {
                                selectedUrges.remove(urge.0)
                            } else {
                                if selectedUrges.count < 2 {
                                    selectedUrges.insert(urge.0)
                                }
                            }
                        }) {
                            Image(systemName: selectedUrges.contains(urge.0) ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(selectedUrges.contains(urge.0) ? .accentColor : .gray)
                        }
                        .padding(.vertical, 8) // Added space around the selection button
                    }
                }
                .padding(.vertical, 12) // Increased space between each list item
            }
            .frame(height: 350) // Limit list height

            // MARK: - Custom Urge Input Section (if needed)
            if selectedUrges.count == 1 {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Custom Urge 1")
                        .font(.headline)
                        .foregroundColor(.gray)
                    TextField("Describe your urge", text: $customUrge1)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                }
                .padding(.vertical, 12)
            }
            if selectedUrges.count == 2 {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Custom Urge 2")
                        .font(.headline)
                        .foregroundColor(.gray)
                    TextField("Describe your urge", text: $customUrge2)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                }
                .padding(.vertical, 12)
            }

            Spacer()

            // MARK: - Continue Button (UI only)
            Text("Continue")
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(selectedUrges.count == 2 ? Color.accentColor : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding(.horizontal)
                .disabled(selectedUrges.count != 2)
        }
        .padding(.horizontal)
    }
}

#Preview {
    UrgesSelectionView()
}
