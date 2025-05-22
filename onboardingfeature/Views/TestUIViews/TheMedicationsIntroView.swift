//
//  TheMedicationsIntroView.swift
//  aura
//
//  Created by Ella A. Sadduq on 4/29/25.
//


// TheMedicationsIntroView.swift
// Aura_iOS

import SwiftUI

struct TheMedicationsIntroView: View {
    @State private var selectedAnswer: String? = nil

    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()

            VStack(spacing: 30) {
                // 🌸 Ultra Light Blobs
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

                Spacer()

                // ✨ Title and Question
                VStack(spacing: 16) {

                    Text("Do you take any daily medications?")
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                        .padding(.top, 10)
                }

                // ✨ Yes / No Buttons
                VStack(spacing: 16) {
                    Button(action: {
                        selectedAnswer = "Yes"
                    }) {
                        Text("Yes")
                            .fontWeight(.medium)
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

                    Button(action: {
                        selectedAnswer = "No"
                    }) {
                        Text("No")
                            .fontWeight(.medium)
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
                }
                .padding(.top, 20)

                Spacer()

                // 🌸 Next Button
                Button(action: {
                    // Handle navigation here
                }) {
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
                .padding(.bottom, 40)
            }
        }
    }
}

#Preview {
    TheMedicationsIntroView()
}
