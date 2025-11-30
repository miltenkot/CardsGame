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
    
    func isMatched(_ text: String, side: ToggleSelectionSide) -> Bool {
        switch side {
        case .left: return matchedLeft.contains(text)
        case .right: return matchedRight.contains(text)
        }
    }
    
    func isMismatched(_ text: String, side: ToggleSelectionSide) -> Bool {
        switch side {
        case .left: return mismatchedLeft == text
        case .right: return mismatchedRight == text
        }
    }
    
    func isVisuallySelected(_ text: String, side: ToggleSelectionSide) -> Bool {
        let isActiveSelection: Bool
        switch side {
        case .left: isActiveSelection = (leftIsSelected == text)
        case .right: isActiveSelection = (rightIsSelected == text)
        }
        return isActiveSelection || isMatched(text, side: side) || isMismatched(text, side: side)
    }
    
    // Stores the task responsible for the countdown (sleep)
    private var currentMatchTask: Task<Void, Never>?
    
    // Stores the code that should be executed after the time elapses (card replacement)
    private var pendingReplacementAction: (() -> Void)?
    
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
        guard let left = leftIsSelected, let right = rightIsSelected else { return }
        
        let selectedLeft = left
        let selectedRight = right
        
        leftIsSelected = nil
        rightIsSelected = nil
        
        if dataLookup[left] == right {
            handleSuccessfulMatch(left: selectedLeft, right: selectedRight)
        } else {
            await handleMismatch(left: selectedLeft, right: selectedRight)
        }
    }
    
    private func handleSuccessfulMatch(left: String, right: String) {
        matchedLeft.insert(left)
        matchedRight.insert(right)
        
        guard let leftPairIndex = visiblePairs.firstIndex(where: { $0.question == left }),
              let rightPairIndex = visiblePairs.firstIndex(where: { $0.answer == right }) else {
            cleanupMatches(left: left, right: right)
            return
        }
        
        withAnimation(.bouncy(duration: matchDelay)) {
            visiblePairs[leftPairIndex].question = ""
            visiblePairs[rightPairIndex].answer = ""
        }
        
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(matchDelay))
            
            guard let newItem = remainingData.popLast() else {
                cleanupMatches(left: left, right: right)
                return
            }
            
            let emptyQuestionIndices = visiblePairs.indices
                .filter { visiblePairs[$0].question.isEmpty }
            
            let emptyAnswerIndices = visiblePairs.indices
                .filter { visiblePairs[$0].answer.isEmpty }
            
            guard let targetQ = emptyQuestionIndices.randomElement(),
                  let targetA = emptyAnswerIndices.randomElement() else {
                cleanupMatches(left: left, right: right)
                return
            }
            withAnimation(.bouncy(duration: matchDelay)) {
                visiblePairs[targetQ].question = newItem.question
                visiblePairs[targetA].answer = newItem.answer
            }
            
            cleanupMatches(left: left, right: right)
        }
    }
    
    private func handleMismatch(left: String, right: String) async {
        isShowingMismatch = true
        
        mismatchedLeft = left
        mismatchedRight = right
        
        try! await Task.sleep(for: .seconds(mismatchDelay))
        
        mismatchedLeft = nil
        mismatchedRight = nil
        
        isShowingMismatch = false
    }
    
    private func cleanupMatches(left: String, right: String) {
        matchedLeft.remove(left)
        matchedRight.remove(right)
    }
}
