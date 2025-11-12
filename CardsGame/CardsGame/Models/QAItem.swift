import Foundation

struct QAItem: Identifiable, Hashable {
    let id = UUID()
    let question: String
    let answer: String
}

extension QAItem {
    static let mock: [QAItem] = [
        QAItem(question: "Capital of France", answer: "Paris"),
        QAItem(question: "1 + 1", answer: "2"),
        QAItem(question: "Color of the sky", answer: "Blue"),
        QAItem(question: "Programming language used for iOS apps", answer: "Swift"),
        QAItem(question: "Leap year has", answer: "366 days"),
        QAItem(question: "Capital of Germany", answer: "Berlin"),
        QAItem(question: "3 * 3", answer: "9"),
        QAItem(question: "Capital of Italy", answer: "Rome"),
        QAItem(question: "Author of 'Pan Tadeusz'", answer: "Adam Mickiewicz"),
        QAItem(question: "Square root of 16", answer: "4"),
        QAItem(question: "Color of grass", answer: "Green"),
        QAItem(question: "Apple's mobile operating system", answer: "iOS"),
        QAItem(question: "Capital of Spain", answer: "Madrid"),
        QAItem(question: "5 - 2", answer: "3"),
        QAItem(question: "Capital of Poland", answer: "Warsaw"),
        QAItem(question: "71 + 5", answer: "76"),
        QAItem(question: "Color of blood", answer: "Red"),
        QAItem(question: "Number of months in a year", answer: "12"),
        QAItem(question: "Hours in a day", answer: "24 hours"),
        QAItem(question: "Capital of Portugal", answer: "Lisbon")
    ]
}
