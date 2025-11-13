import SwiftUI

struct GameObservableView: View {
    @Observable final class Game {
        let data = QAItem.mock
        
        var leftIsSelected: String?
        var rightIsSelected: String?
        
        let padding: CGFloat = 16
        let maxVisibleRows: Int = 5
        let spacing: CGFloat = 12
    }
    
    @State private var game = Game()
    
    var body: some View {
        GeometryReader { geo in
            let availableHeight = geo.size.height - (game.padding * 3)
            let rowHeight = max(
                (availableHeight - (CGFloat(game.maxVisibleRows - 1) * game.spacing)) / CGFloat(max(game.maxVisibleRows, 1)),
                0
            )
            
            Grid(horizontalSpacing: game.spacing, verticalSpacing: game.spacing) {
                ForEach(game.data.prefix(5)) { data in
                    GridRow {
                        let leftTitle = data.question
                        CardViewObservable(
                            title: leftTitle,
                            isSelected: game.leftIsSelected == leftTitle,
                            onTap: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    if game.leftIsSelected == leftTitle {
                                        game.leftIsSelected = nil
                                    } else {
                                        game.leftIsSelected = leftTitle
                                    }
                                }
                            },
                            height: rowHeight
                        )
                        
                        let rightTitle = data.answer
                        CardViewObservable(
                            title: rightTitle,
                            isSelected: game.rightIsSelected == rightTitle,
                            onTap: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    if game.rightIsSelected == rightTitle {
                                        game.rightIsSelected = nil
                                    } else {
                                        game.rightIsSelected = rightTitle
                                    }
                                }
                            },
                            height: rowHeight
                        )
                    }
                }
            }
            .padding(game.padding)
        }
    }
}
