import UIKit

class Task: NSObject {
    
    var text: String
    var completed: Bool
    var id: Int
    var beacon: Beacon
    var questions: [Question]
    
    init(text: String, id: Int, beacon: Beacon, questions: [Question]) {
        self.text = text
        self.completed = false
        self.id = id
        self.beacon = beacon
        self.questions = questions
    }
   
}
