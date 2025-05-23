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
//  Created by Ella A. Sadduq on 5/22/25.
//

import SwiftUI

struct RatingCardView: View {
    let title: String
    let description: String
    @Binding var value: Double
    
    var body: some View {
        HStack(spacing: 20) {
            // Elegant 3D icon (same as MainView)
            Image(systemName: "heart.text.square")
                .font(.system(size: 28, weight: .light))
                .foregroundColor(.primary.opacity(0.8))
                .shadow(color: .primary.opacity(0.1), radius: 2, x: 1, y: 1)
                .shadow(color: .white.opacity(0.8), radius: 1, x: -0.5, y: -0.5)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.system(size: 19, weight: .medium))
                    .foregroundColor(.primary.opacity(0.9))
                
                Text(description)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.secondary.opacity(0.6))
                
                // Rating slider
                VStack(spacing: 6) {
                    HStack {
                        Text("0")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.secondary.opacity(0.5))
                        
                        Slider(value: $value, in: 0...10, step: 1)
                        
                        Text("10")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.secondary.opacity(0.5))
                    }
                    
                    Text("Rating: \(Int(value))")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.secondary.opacity(0.6))
                }
            }
            
            Spacer()
        }
        .padding(28)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(.systemBackground).opacity(0.8))
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.04), radius: 20, x: 0, y: 8)
                .shadow(color: .black.opacity(0.02), radius: 1, x: 0, y: 1)
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
