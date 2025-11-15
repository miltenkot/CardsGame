import SwiftUI

struct CardViewObservable: View, Equatable {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void
    let isCorrect: Bool
    var height: CGFloat = 80
    let cornerRadius: CGFloat = 12
    
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
                selectionColor: isCorrect ? Color.green : Color.accentColor,
                selectionBackgroundColor: isCorrect ? Color.green.opacity(0.3) : Color.accentColor.opacity(0.15),
                cornerRadius: cornerRadius,
                height: height
            )
        )
        .accessibilityLabel(title)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .disabled(isCorrect)
    }
    
    static func == (lhs: CardViewObservable, rhs: CardViewObservable) -> Bool {
        return lhs.title == rhs.title &&
        lhs.isSelected == rhs.isSelected &&
        lhs.isCorrect == rhs.isCorrect &&
        lhs.height == rhs.height &&
        lhs.cornerRadius == rhs.cornerRadius
    }
}
