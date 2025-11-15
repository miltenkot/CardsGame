import SwiftUI

struct CardViewObservable: View, Equatable {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var selectionColor: Color = .accentColor
    var selectionBackgroundColor: Color = Color.accentColor.opacity(0.15)
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
                selectionColor: selectionColor,
                selectionBackgroundColor: selectionBackgroundColor,
                cornerRadius: cornerRadius,
                height: height
            )
        )
        .accessibilityLabel(title)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
    
    static func == (lhs: CardViewObservable, rhs: CardViewObservable) -> Bool {
        return lhs.title == rhs.title &&
        lhs.isSelected == rhs.isSelected &&
        lhs.selectionColor == rhs.selectionColor &&
        lhs.selectionBackgroundColor == rhs.selectionBackgroundColor &&
        lhs.height == rhs.height &&
        lhs.cornerRadius == rhs.cornerRadius
    }
}
