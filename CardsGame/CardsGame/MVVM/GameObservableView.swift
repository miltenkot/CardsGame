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
                ForEach(0..<game.maxVisibleRows, id: \.self) { row in
                    GridRow {
                        CardView(title: game.data[row].question, isSelected: $game.leftIsSelected, height: rowHeight)
                        CardView(title: game.data[row].answer, isSelected: $game.rightIsSelected, height: rowHeight)
                    }
                }
            }
            .padding(game.padding)
        }
    }
}

#Preview {
    GameView()
}
