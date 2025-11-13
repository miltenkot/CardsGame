import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    var isSelected: Bool
    var selectionColor: Color
    var selectionBackgroundColor: Color
    var cornerRadius: CGFloat
    var height: CGFloat
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(isSelected ? selectionColor : .primary)
            .padding()
            .frame(height: height)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(isSelected ? selectionBackgroundColor : Color(.systemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(isSelected ? selectionColor : Color.secondary.opacity(0.3),
                            lineWidth: isSelected ? 3 : 1)
            )
            .shadow(color: Color.black.opacity(0.08), radius: 3, x: 0, y: 2)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}
