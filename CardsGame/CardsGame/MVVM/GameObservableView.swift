import SwiftUI

struct GameObservableView: View {
    @MainActor
    @Observable final class Game {
        let data = QAItem.mock
        
        var leftIsSelected: String?
        var rightIsSelected: String?
        
        let shuffledQuestions: [String]
        let shuffledAnswers: [String]
        
        let maxVisibleRows = 5
        
        init() {
            let dataSubset = Array(data.shuffled().prefix(maxVisibleRows))
            
            let questions = dataSubset.map(\.question)
            let answers = dataSubset.map(\.answer)
            
            self.shuffledQuestions = questions.shuffled()
            self.shuffledAnswers = answers.shuffled()
        }
        
        enum ToggleSelectionSide {
            case left
            case right
        }
        
        func toggleSelection(_ title: String, for side: ToggleSelectionSide) {
            switch side {
            case .left:
                toggleSelection(property: &leftIsSelected, title: title)
            case .right:
                toggleSelection(property: &rightIsSelected, title: title)
            }
            
        }
        
        private func toggleSelection(property: inout String?, title: String) {
            if property == title {
                property = nil
            } else {
                property = title
            }
        }
    }
    
    @State private var game = Game()
    
    let padding: CGFloat = 16
    let maxVisibleRows: Int = 5
    let spacing: CGFloat = 12
    
    var body: some View {
        GeometryReader { geo in
            let availableHeight = geo.size.height - (padding * 3)
            let rowHeight = max(
                (availableHeight - (CGFloat(maxVisibleRows - 1) * spacing)) / CGFloat(max(maxVisibleRows, 1)),
                0
            )
            
            Grid(horizontalSpacing: spacing, verticalSpacing: spacing) {
                ForEach(game.shuffledQuestions.indices, id: \.self) { index in
                    GridRow {
                        let leftTitle = game.shuffledQuestions[index]
                        CardViewObservable(
                            title: leftTitle,
                            isSelected: game.leftIsSelected == leftTitle,
                            onTap: { game.toggleSelection(leftTitle, for: .left) },
                            height: rowHeight
                        )
                        
                        let rightTitle = game.shuffledAnswers[index]
                        CardViewObservable(
                            title: rightTitle,
                            isSelected: game.rightIsSelected == rightTitle,
                            onTap: { game.toggleSelection(rightTitle, for: .right) },
                            height: rowHeight
                        )
                    }
                }
            }
            .padding(padding)
        }
    }
}
