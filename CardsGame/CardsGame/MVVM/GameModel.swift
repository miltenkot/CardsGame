import SwiftUI

@MainActor
@Observable final class GameModel {
    let data = QAItem.mock
    
    let dataLookup: [String: String]
    
    var remainingData: [QAItem]
    
    var leftIsSelected: String?
    var rightIsSelected: String?
    
    var visiblePairs: [QAItem]
    
    let maxVisibleRows = GameConfig.maxVisibleRows
    let matchDelay = GameConfig.matchDelay
    
    var matchedLeft: Set<String> = []
    var matchedRight: Set<String> = []
    
    var mismatchedLeft: String?
    var mismatchedRight: String?
    var isShowingMismatch = false
    let mismatchDelay = GameConfig.mismatchDelay
    
    init() {
        let allData = data.shuffled()
        
        self.dataLookup = Dictionary(uniqueKeysWithValues: allData.map { ($0.question, $0.answer) })
        
        let dataSubset = Array(allData.prefix(maxVisibleRows))
        var remaining = Array(allData.dropFirst(maxVisibleRows))
        
        remaining.reverse()
        self.remainingData = remaining
        
        let shuffledQuestions = dataSubset.map(\.question).shuffled()
        let shuffledAnswers = dataSubset.map(\.answer).shuffled()
        
        self.visiblePairs = []
        for i in 0..<dataSubset.count {
            self.visiblePairs.append(
                QAItem(question: shuffledQuestions[i], answer: shuffledAnswers[i])
            )
        }
    }
    
    enum ToggleSelectionSide {
        case left
        case right
    }
    
    func toggleSelection(_ title: String, for side: ToggleSelectionSide) {
        if title.isEmpty || isShowingMismatch { return }
        
        switch side {
        case .left:
            toggleSelection(property: &leftIsSelected, title: title)
        case .right:
            toggleSelection(property: &rightIsSelected, title: title)
        }
        
        Task {
            await checkForMatch()
        }
    }
    
    private func toggleSelection(property: inout String?, title: String) {
        if property == title {
            property = nil
        } else {
            property = title
        }
    }
    
    private func checkForMatch() async {
        guard let left = leftIsSelected, let right = rightIsSelected else {
            return
        }
        
        let selectedLeft = left
        let selectedRight = right
        
        leftIsSelected = nil
        rightIsSelected = nil
        
        if dataLookup[left] == right {
            matchedLeft.insert(selectedLeft)
            matchedRight.insert(selectedRight)
            
            try! await Task.sleep(for: .seconds(matchDelay))
            
            guard let leftPairIndex = visiblePairs.firstIndex(where: { $0.question == left }),
                  let rightPairIndex = visiblePairs.firstIndex(where: { $0.answer == right }) else {
                cleanupMatches(left: left, right: right)
                return
            }
            
            if let newItem = remainingData.popLast() {
                visiblePairs[leftPairIndex].question = newItem.question
                visiblePairs[rightPairIndex].answer = newItem.answer
            } else {
                visiblePairs[leftPairIndex].question = ""
                visiblePairs[rightPairIndex].answer = ""
            }
            
            cleanupMatches(left: left, right: right)
        } else {
            isShowingMismatch = true
            
            mismatchedLeft = selectedLeft
            mismatchedRight = selectedRight
            
            try! await Task.sleep(for: .seconds(mismatchDelay))
            
            mismatchedLeft = nil
            mismatchedRight = nil
            
            isShowingMismatch = false
        }
    }
    
    private func cleanupMatches(left: String, right: String) {
        matchedLeft.remove(left)
        matchedRight.remove(right)
    }
}
