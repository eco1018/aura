//
//  SharedMedicationComponents.swift
//  aura
//
//  Created by Ella A. Sadduq on 5/23/25.
//

//
//  SharedMedicationComponents.swift
//  aura
//
//  Created by Ella A. Sadduq on 5/23/25.
//
//  Shared UI components for medication features

import SwiftUI

// MARK: - Shared Selected Medication Card
struct SharedSelectedMedicationCard: View {
    let medication: Medication
    let onRemove: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(medication.displayName)
                    .font(.body)
                    .fontWeight(.medium)
                
                HStack {
                    if let strength = medication.strength {
                        Text(strength)
                            .font(.caption)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(4)
                    }
                    
                    if let form = medication.dosageForm {
                        Text(form)
                            .font(.caption)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(4)
                    }
                    
                    Text(medication.frequency.displayName)
                        .font(.caption)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(4)
                }
                
                if let genericName = medication.genericName, genericName != medication.name {
                    Text("Generic: \(genericName)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Text("RxCUI: \(medication.rxcui)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .opacity(0.7)
            }
            
            Spacer()
            
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title3)
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.green.opacity(0.1))
                .stroke(Color.green.opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Shared Search Result Card
struct SharedSearchResultCard: View {
    let result: BasicMedicationSearchResult
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(result.displayName)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    if let synonym = result.synonym, synonym != result.name {
                        Text("Also: \(synonym)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Text("RxCUI: \(result.rxcui)")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .opacity(0.7)
                }
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "plus.circle")
                    .font(.title3)
                    .foregroundColor(isSelected ? .green : .blue)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
                    .stroke(isSelected ? Color.green.opacity(0.5) : Color.clear, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
