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
            let safeCount = min(game.visibleQuestions.count, game.visibleAnswers.count)
            
            ZStack {
                Grid(horizontalSpacing: spacing, verticalSpacing: spacing) {
                    ForEach(0..<safeCount, id: \.self) { index in
                        GridRow {
                            let leftTitle = game.visibleQuestions[index]
                            CardViewObservable(
                                title: leftTitle,
                                isSelected: game.leftIsSelected == leftTitle || game.matchedLeft == leftTitle,
                                onTap: { game.toggleSelection(leftTitle, for: .left) },
                                isCorrect: game.matchedLeft == leftTitle,
                                height: rowHeight
                            )
                            
                            let rightTitle = game.visibleAnswers[index]
                            CardViewObservable(
                                title: rightTitle,
                                isSelected: game.rightIsSelected == rightTitle || game.matchedRight == rightTitle,
                                onTap: { game.toggleSelection(rightTitle, for: .right) },
                                isCorrect: game.matchedRight == rightTitle,
                                height: rowHeight
                            )
                        }
                    }
                }
                .padding(padding)
            }
        }
    }
}

#Preview {
    GameObservableView()
}
