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
                                isSelected: game.leftIsSelected == pair.question || game.matchedLeft == pair.question || game.mismatchedLeft == pair.question,
                                onTap: { game.toggleSelection(pair.question, for: .left) },
                                isCorrect: game.matchedLeft == pair.question,
                                isIncorrect: game.mismatchedLeft == pair.question,
                                height: rowHeight
                            )
                            
                            CardViewObservable(
                                title: pair.answer,
                                isSelected: game.rightIsSelected == pair.answer || game.matchedRight == pair.answer || game.mismatchedRight == pair.answer,
                                onTap: { game.toggleSelection(pair.answer, for: .right) },
                                isCorrect: game.matchedRight == pair.answer,
                                isIncorrect: game.mismatchedRight == pair.answer,
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
