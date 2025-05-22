//ActionsView.swift

import SwiftUI

struct ActionsView: View {
    var customActionTitles: [String]
    @State private var togglesState: [Bool]

    init(customActionTitles: [String]) {
        self.customActionTitles = customActionTitles
        _togglesState = State(initialValue: Array(repeating: false, count: 5))
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Spacer(minLength: 20) // Pushes content down
                
                VStack(spacing: 24) {
                    
                    // Instruction Header
                    Text("Take a moment to gently check in with yourself — have you engaged in any of these actions today?")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                    
                    // Toggle Group
                    VStack(spacing: 1) {
                        ForEach(0..<togglesState.count, id: \.self) { index in
                            HStack {
                                Text(actionTitle(for: index))
                                    .font(.body)
                                    .foregroundColor(.primary)
                                Spacer()
                                Toggle("", isOn: $togglesState[index])
                                    .labelsHidden()
                                    .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                            }
                            .padding(.horizontal, 20)
                            .frame(height: 56)
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(index == 0 ? 12 : (index == togglesState.count - 1 ? 12 : 0), corners: index == 0 ? [.topLeft, .topRight] : (index == togglesState.count - 1 ? [.bottomLeft, .bottomRight] : []))
                            .overlay(
                                Divider()
                                    .padding(.leading, 20)
                                    .opacity(index == togglesState.count - 1 ? 0 : 1),
                                alignment: .bottom
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                }
                
                Spacer() // This Spacer pushes the entire VStack toward bottom naturally
                
                // Submit Button
                Button(action: submitAction) {
                    Text("Submit")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal, 20)
                }
                .padding(.bottom, 24)
            }
            .navigationTitle("Actions")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    backButton
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    cancelButton
                }
            }
            .background(Color(UIColor.systemGroupedBackground))
            .ignoresSafeArea(.keyboard) // Important for perfect behavior
        }
    }
    
    // MARK: - UI Components

    private var backButton: some View {
        Button(action: {
            print("Back pressed")
        }) {
            Image(systemName: "chevron.left")
                .font(.body.weight(.semibold))
                .foregroundColor(.accentColor)
        }
    }
    
    private var cancelButton: some View {
        Button(action: {
            print("Cancel pressed")
        }) {
            Text("Cancel")
                .font(.body)
                .foregroundColor(.accentColor)
        }
    }
    
    private func actionTitle(for index: Int) -> String {
        if customActionTitles.isEmpty {
            return actionOptions[index]
        } else if index < customActionTitles.count {
            return customActionTitles[index]
        } else {
            return ""
        }
    }
    
    private var actionOptions: [String] {
        [
            "Self Harm",
            "Suicide Attempt",
            "Lashing Out at Others",
            "Disordered Eating",
            "Substance Use"
        ]
    }
    
    private func submitAction() {
        print("Actions submitted")
    }
}

// MARK: - Rounded Corner Helper
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = 12
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - Preview

struct ActionsView_Previews: PreviewProvider {
    static var previews: some View {
        ActionsView(customActionTitles: [])
            .previewDevice("iPhone 15 Pro")
            .preferredColorScheme(.light)
        ActionsView(customActionTitles: [])
            .previewDevice("iPhone 15 Pro")
            .preferredColorScheme(.dark)
    }
}
