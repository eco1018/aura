//
//  TheLastNameView.swift
//  aura
//
//  Created by Ella A. Sadduq on 4/29/25.
//


// TheLastNameView.swift
// Aura_iOS

import SwiftUI

struct TheLastNameView: View {
    @State private var selectedAnswer: String = ""

    var body: some View {
        ZStack {
            GlassmorphicBackground()
                .ignoresSafeArea()

            ParticleOverlay()
                .ignoresSafeArea()

            VStack(spacing: 30) {
               

                Spacer()

                Text("What's your last name?")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                    .padding(.horizontal)

                OnboardingTextField(
                    placeholder: "Last Name",
                    text: $selectedAnswer
                )

                Spacer()
            }
            .padding(.bottom, 30)
        }
    }
}

struct AOnboardingTextField: View {
    var placeholder: String
    @Binding var text: String

    var body: some View {
        HStack(spacing: 12) {
            TextField(placeholder, text: $text)
                .keyboardType(.default)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .padding(.vertical, 14)
                .padding(.horizontal, 20)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color("Background"))
                        .shadow(color: .white.opacity(0.8), radius: 6, x: -6, y: -6)
                        .shadow(color: .black.opacity(0.1), radius: 6, x: 6, y: 6)
                )

            Button(action: {}) {
                ZStack {
                    Circle()
                        .fill(Color("Background"))
                        .shadow(color: .white.opacity(0.9), radius: 6, x: -4, y: -4)
                        .shadow(color: .black.opacity(0.1), radius: 6, x: 4, y: 4)
                        .overlay(
                            Circle()
                                .stroke(
                                    AngularGradient(
                                        gradient: Gradient(colors: [
                                            Color.white.opacity(0.3),
                                            Color.purple.opacity(0.1),
                                            Color.clear
                                        ]),
                                        center: .center
                                    ),
                                    lineWidth: 2
                                )
                        )
                        .scaleEffect(1.02)
                        .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: text)

                    Image(systemName: "arrow.right")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
                .frame(width: 48, height: 48)
                .contentShape(Circle())
            }
        }
        .padding(.horizontal)
    }
}

struct AGlassmorphicBackground: View {
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

struct AParticleOverlay: View {
    @State private var animate = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<15, id: \.self) { _ in
                    Circle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: CGFloat.random(in: 3...8), height: CGFloat.random(in: 3...8))
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: animate ? geometry.size.height + 60 : -60
                        )
                        .animation(Animation.linear(duration: Double.random(in: 12...20)).repeatForever(autoreverses: false), value: animate)
                }
            }
            .onAppear {
                animate = true
            }
        }
    }
}




#Preview {
    TheLastNameView()
}
