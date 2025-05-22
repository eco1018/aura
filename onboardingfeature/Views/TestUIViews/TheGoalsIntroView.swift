//
//  TheGoalsIntroView.swift
//  aura
//
//  Created by Ella A. Sadduq on 4/29/25.
//

// GoalsIntroView.swift
// Aura_iOS

import SwiftUI

struct TheGoalsIntroView: View {
    var body: some View {
        ZStack {
            GlassmorphicBackground()
                .ignoresSafeArea()

            ParticleOverlay()
                .ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()

                // 🌿 Title
                Text("Let’s Focus on Your Goals")
                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                    .padding(.horizontal)

                // 🌱 Description
                Text("""
                This step will help you reflect on the goals you want to track — and give you a way to visualize your progress over time.
                """)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)

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
                                .shadow(color: .white.opacity(0.7), radius: 6, x: -6, y: -6)
                                .shadow(color: .black.opacity(0.15), radius: 6, x: 6, y: 6)
                        )
                }
                .padding(.horizontal, 40)
            }
            .padding(.bottom, 30)
        }
    }
}

// MARK: - Shared Components

struct GlassmorphicBackground: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.white.opacity(0.2),
                Color.purple.opacity(0.1),
                Color.blue.opacity(0.05)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .background(.ultraThinMaterial)
        .blur(radius: 30)
    }
}

struct ParticleOverlay: View {
    @State private var animate = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<15, id: \.self) { _ in
                    Circle()
                        .fill(Color.white.opacity(0.08))
                        .frame(width: CGFloat.random(in: 3...8), height: CGFloat.random(in: 3...8))
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: animate ? geometry.size.height + 60 : -60
                        )
                        .animation(Animation.linear(duration: Double.random(in: 14...20)).repeatForever(autoreverses: false), value: animate)
                }
            }
            .onAppear {
                animate = true
            }
        }
    }
}

#Preview {
    TheGoalsIntroView()
}
