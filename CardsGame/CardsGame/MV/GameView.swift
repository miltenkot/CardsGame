import SwiftUI

struct GameView: View {
    let padding: CGFloat = 16
    let maxVisibleRows: Int = 5
    let spacing: CGFloat = 12
    
    @State private var leftIsSelected: String?
    @State private var rightIsSelected: String?
    
    let data = QAItem.mock
    
    var availableData: [QAItem] {
        Array(data.prefix(5))
    }
    
    var body: some View {
        GeometryReader { geo in
            let availableHeight = geo.size.height - (padding * 3)
            let rowHeight = max(
                (availableHeight - (CGFloat(maxVisibleRows - 1) * spacing)) / CGFloat(max(maxVisibleRows, 1)),
                0
            )
            Grid(horizontalSpacing: spacing, verticalSpacing: spacing) {
                ForEach(availableData) { data in
                    GridRow {
                        CardView(
                            title: data.question,
                            isSelected: $leftIsSelected,
                            height: rowHeight
                        )
                        CardView(
                            title: data.answer,
                            isSelected: $rightIsSelected,
                            height: rowHeight
                        )
                    }
                }
            }
            .padding(padding)
        }
    }
}

#Preview {
    GameView()
}
