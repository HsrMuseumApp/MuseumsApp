import UIKit

class Answer: NSObject {
    var id: Int
    var text: String
    var correct: Bool
    
    init(id: Int, text: String, correct: Bool) {
        self.id = id
        self.text = text
        self.correct = correct
    }
}
