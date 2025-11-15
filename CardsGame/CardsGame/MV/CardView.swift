import SwiftUI

struct CardView: View {
    let title: String
    @Binding var isSelected: String?
    var selectionColor: Color = .accentColor
    var selectionBackgroundColor: Color = Color.accentColor.opacity(0.15)
    var height: CGFloat = 80
    let cornerRadius: CGFloat = 12
    
    var body: some View {
        let _ = print("update view")
        Button {
            if isSelected == title {
                isSelected = nil
            } else {
                isSelected = title
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
