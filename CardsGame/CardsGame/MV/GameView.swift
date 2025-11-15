import SwiftUI

struct GameView: View {
    private let data = QAItem.mock
    private let padding: CGFloat = 16
    private let spacing: CGFloat = 12
    
    private let dataLookup: [String: String]
    
    @State private var remainingData: [QAItem]
    
    @State private var leftIsSelected: String?
    @State private var rightIsSelected: String?
    
    @State private var visibleQuestions: [String]
    @State private var visibleAnswers: [String]
    
    private let maxVisibleRows = 5
    
    init() {
        let allData = data.shuffled()
        
        self.dataLookup = Dictionary(uniqueKeysWithValues: allData.map { ($0.question, $0.answer) })
        
        let dataSubset = Array(allData.prefix(maxVisibleRows))
        var remaining = Array(allData.dropFirst(maxVisibleRows))
        
        remaining.reverse()
        self.remainingData = remaining
        
        self.visibleQuestions = dataSubset.map(\.question).shuffled()
        self.visibleAnswers = dataSubset.map(\.answer).shuffled()
    }
    
    var body: some View {
        GeometryReader { geo in
            let availableHeight = geo.size.height - (padding * 3)
            let rowHeight = max(
                (availableHeight - (CGFloat(maxVisibleRows - 1) * spacing)) / CGFloat(max(maxVisibleRows, 1)),
                0
            )
            Grid(horizontalSpacing: spacing, verticalSpacing: spacing) {
                ForEach(visibleQuestions.indices, id: \.self) { index in
                    GridRow {
                        if index < visibleQuestions.count && index < visibleAnswers.count {
                            let leftTitle = visibleQuestions[index]
                            CardView(
                                title: leftTitle,
                                isSelected: $leftIsSelected,
                                height: rowHeight
                            )
                            let rightTitle = visibleAnswers[index]
                            CardView(
                                title: rightTitle,
                                isSelected: $rightIsSelected,
                                height: rowHeight
                            )
                        }
                    }
                }
            }
            .padding(padding)
            .onChange(of: leftIsSelected) {
                checkForMatch()
            }
            .onChange(of: rightIsSelected) {
                checkForMatch()
            }
        }
    }
    
    private func checkForMatch() {
        guard let left = leftIsSelected, let right = rightIsSelected else {
            return
        }
        
        if dataLookup[left] == right {
            guard let leftIndex = visibleQuestions.firstIndex(of: left),
                  let rightIndex = visibleAnswers.firstIndex(of: right) else {
                return
            }
            
            if let newItem = remainingData.popLast() {
                visibleQuestions[leftIndex] = newItem.question
                visibleAnswers[rightIndex] = newItem.answer
            } else {
                visibleQuestions[leftIndex] = ""
                visibleAnswers[rightIndex] = ""
            }
            
            leftIsSelected = nil
            rightIsSelected = nil
        }
    }
}

#Preview {
    GameView()
}
