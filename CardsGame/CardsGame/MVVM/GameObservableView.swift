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
                    ForEach(game.visibleQuestions.indices, id: \.self) { index in
                        GridRow {
                            if index < game.visibleQuestions.count && index < game.visibleAnswers.count {
                                
                                let leftTitle = game.visibleQuestions[index]
                                CardViewObservable(
                                    title: leftTitle,
                                    isSelected: game.leftIsSelected == leftTitle,
                                    onTap: { game.toggleSelection(leftTitle, for: .left) },
                                    height: rowHeight
                                )
                                
                                let rightTitle = game.visibleAnswers[index]
                                CardViewObservable(
                                    title: rightTitle,
                                    isSelected: game.rightIsSelected == rightTitle,
                                    onTap: { game.toggleSelection(rightTitle, for: .right) },
                                    height: rowHeight
                                )
                            }
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
