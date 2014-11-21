import UIKit

class Task: NSObject {
    
    var text: String
    var completed: Bool
    var id: Int
    var beacon: Beacon
    var answers: [Answer]
    
    init(text: String, id: Int, beacon: Beacon, answers: [Answer]) {
        self.text = text
        self.completed = false
        self.id = id
        self.beacon = beacon
        self.answers = answers
    }
   
}
