import SwiftUI

struct CardViewObservable: View, Equatable {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void
    let isCorrect: Bool
    let isIncorrect: Bool
    var height: CGFloat = 80
    let cornerRadius: CGFloat = 12
    
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
