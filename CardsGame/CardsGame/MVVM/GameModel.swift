import SwiftUI

@MainActor
@Observable final class GameModel {
    let data = QAItem.mock
    
    let dataLookup: [String: String]
    
    var remainingData: [QAItem]
    
    var leftIsSelected: String?
    var rightIsSelected: String?
    
    var visibleQuestions: [String]
    var visibleAnswers: [String]
    
    let maxVisibleRows = 5
    
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
    
    enum ToggleSelectionSide {
        case left
        case right
    }
    
    func toggleSelection(_ title: String, for side: ToggleSelectionSide) {
        if title.isEmpty { return }
        
        switch side {
        case .left:
            toggleSelection(property: &leftIsSelected, title: title)
        case .right:
            toggleSelection(property: &rightIsSelected, title: title)
        }
        
        checkForMatch()
    }
    
    private func toggleSelection(property: inout String?, title: String) {
        if property == title {
            property = nil
        } else {
            property = title
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
