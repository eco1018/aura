//
//  RatingCardView.swift
//  aura
//
//  Created by Ella A. Sadduq on 5/22/25.
//


//
//  RatingCardView.swift
//  aura
//
//  Created by Ella A. Sadduq on 3/28/25.
//

import SwiftUI

struct RatingCardView: View {
    let title: String
    let description: String
    @Binding var value: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Title and description
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.medium)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // Rating controls
            VStack(spacing: 8) {
                // Slider with labels
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

#Preview {
    RatingCardView(
        title: "Self-harm urges",
        description: "Rate the intensity of self-harm urges today",
        value: .constant(3.0)
    )
    .padding()
}