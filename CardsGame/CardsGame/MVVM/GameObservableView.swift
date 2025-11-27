import SwiftUI

struct GameObservableView: View {
    
    @State private var game = GameModel()
    
    let padding: CGFloat = 16
    let spacing: CGFloat = 12
    
    var body: some View {
        GeometryReader { geo in
            let availableHeight = geo.size.height - (padding * 3)
            let rowHeight = max(
                (availableHeight - (CGFloat(game.maxVisibleRows - 1) * spacing)) / CGFloat(max(game.maxVisibleRows, 1)),
                0
            )
            
            ZStack {
                Grid(horizontalSpacing: spacing, verticalSpacing: spacing) {
                    ForEach(game.visiblePairs) { pair in
                        GridRow {
                            CardViewObservable(
                                title: pair.question,
                                isSelected: game.isVisuallySelected(pair.question, side: .left),
                                onTap: { game.toggleSelection(pair.question, for: .left) },
                                isCorrect: game.isMatched(pair.question, side: .left),
                                isIncorrect: game.isMismatched(pair.question, side: .left),
                                height: rowHeight
                            )
                            
                            CardViewObservable(
                                title: pair.answer,
                                isSelected: game.isVisuallySelected(pair.answer, side: .right),
                                onTap: { game.toggleSelection(pair.answer, for: .right) },
                                isCorrect: game.isMatched(pair.answer, side: .right),
                                isIncorrect: game.isMismatched(pair.answer, side: .right),
                                height: rowHeight
                            )
                        }
                    }
                }
                .padding(padding)
                .disabled(game.isShowingMismatch)
            }
        }
    }
}

#Preview {
    GameObservableView()
}
