//
//  TheActionsIntroView.swift
//  aura
//
//  Created by Ella A. Sadduq on 4/29/25.
//
// TheActionsIntroView.swift
// Aura_iOS

import SwiftUI

struct TheActionsIntroView: View {
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()

            VStack(spacing: 20) {
                // 🌸 Soft Blobs
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.yellow.opacity(0.15),
                                    Color.orange.opacity(0.12)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .blur(radius: 80)
                        .offset(x: -40, y: -30)

                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.purple.opacity(0.15),
                                    Color.blue.opacity(0.12)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .blur(radius: 80)
                        .offset(x: 40, y: 30)
                }
                .frame(width: 240, height: 240)
                .padding(.top, 20)

                // ✨ Title and Description in Center Top Area
                VStack(spacing: 20) {
                    Text("Let’s Start with Actions")
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)

                    Text("""
                    In DBT, “actions” are behaviors that often come up when we’re in distress.

                    You’ll always track two common ones — self-harm and suicidal thoughts — and then choose a few more that feel personally relevant to you.
                    """)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                }
                .padding(.top, 10)
                
                Spacer()

                // 🌸 Soft "Next" Button
                Button(action: {}) {
                    Text("Next")
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color("Background"))
                                .shadow(color: .white.opacity(0.8), radius: 6, x: -6, y: -6)
                                .shadow(color: .black.opacity(0.15), radius: 6, x: 6, y: 6)
                        )
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
            .frame(maxHeight: .infinity, alignment: .top) // <-- LIFT everything toward top half
        }
    }
}

#Preview {
    TheActionsIntroView()
}
