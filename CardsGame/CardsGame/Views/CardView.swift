import SwiftUI

struct CardView: View {
    let title: String
    @Binding var isSelected: String?
    var selectionColor: Color = .accentColor
    var selectionBackgroundColor: Color = Color.accentColor.opacity(0.15)
    var height: CGFloat = 80
    let cornerRadius: CGFloat = 12
    
    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                if isSelected == title {
                    isSelected = nil
                } else {
                    isSelected = title
                }
            }
        } label: {
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(
            PrimaryButtonStyle(
                isSelected: isSelected == title,
                selectionColor: selectionColor,
                selectionBackgroundColor: selectionBackgroundColor,
                cornerRadius: cornerRadius,
                height: height
            )
        )
        .accessibilityLabel(title)
        .accessibilityAddTraits(isSelected == title ? .isSelected : [])
    }
}

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

#Preview {
    @Previewable @State var selected1: String? = nil
    @Previewable @State var selected2: String? = ""
    @Previewable @State var selected3: String? = "true"
    
    VStack(spacing: 16) {
        CardView(title: "Not selected", isSelected: $selected1)
        
        CardView(
            title: "Selected non-matching",
            isSelected: $selected2,
            selectionColor: .blue,
            selectionBackgroundColor: Color.blue.opacity(0.15)
        )
        
        CardView(
            title: "Selected matching",
            isSelected: $selected3,
            selectionColor: .green,
            selectionBackgroundColor: Color.green.opacity(0.25)
        )
    }
    .padding()
}
