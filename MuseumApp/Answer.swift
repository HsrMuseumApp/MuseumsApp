import UIKit

class Answer: NSObject {
    var text: String
    var correct: Bool
    
    init(text: String, correct: Bool) {
        self.text = text
        self.correct = correct
    }
}
