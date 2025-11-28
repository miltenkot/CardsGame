import SwiftUI

struct CardViewObservable: View, Equatable {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void
    let isCorrect: Bool
    let isIncorrect: Bool
    var height: CGFloat = 80
    let cornerRadius: CGFloat = 12
    
    @State private var triggerBounce = 0
    
    private var dynamicSelectionColor: Color {
        if isIncorrect { return .red }
        if isCorrect { return .green }
        return .accentColor
    }
    
    private var dynamicBackgroundColor: Color {
        if isIncorrect { return .red.opacity(0.3) }
        if isCorrect { return .green.opacity(0.3) }
        return .accentColor.opacity(0.15)
    }
    
    var body: some View {
        let _ = print("state changed \(title)")
        Button {
            onTap()
        } label: {
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .opacity(isCorrect ? 0 : 1)
                .scaleEffect(isCorrect ? 0.7 : 1.0)
                .animation(.easeIn(duration: GameConfig.matchDelay), value: isCorrect)
                .id(title)
                .transition(.opacity)
        }
        .buttonStyle(
            PrimaryButtonStyle(
                isSelected: isSelected,
                selectionColor: dynamicSelectionColor,
                selectionBackgroundColor: dynamicBackgroundColor,
                cornerRadius: cornerRadius,
                height: height
            )
        )
        .keyframeAnimator(
            initialValue: 1.0,
            trigger: triggerBounce
        ) { view, scale in
            view.scaleEffect(scale)
        } keyframes: { _ in
            KeyframeTrack(\.self) {
                SpringKeyframe(1.05, duration: 0.2, spring: .snappy)
                SpringKeyframe(1.0, duration: 0.2, spring: .snappy)
            }
        }
        .onChange(of: isCorrect) { oldValue, newValue in
            if newValue == true && oldValue == false {
                triggerBounce += 1
            }
        }
        .accessibilityLabel(title)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .disabled(isCorrect || isIncorrect)
    }
    
    static func == (lhs: CardViewObservable, rhs: CardViewObservable) -> Bool {
        return lhs.title == rhs.title &&
        lhs.isSelected == rhs.isSelected &&
        lhs.isCorrect == rhs.isCorrect &&
        lhs.isIncorrect == rhs.isIncorrect &&
        lhs.height == rhs.height &&
        lhs.cornerRadius == rhs.cornerRadius
    }
}
