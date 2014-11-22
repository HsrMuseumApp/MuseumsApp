import UIKit

class Task: NSObject {
    
    var text: String
    var completed: Bool {
        didSet {
            var defaults = NSUserDefaults.standardUserDefaults()
            var answeredQuestions: [Int]? = defaults.objectForKey("answeredQuestions") as [Int]?
            if(answeredQuestions != nil) {
                for actualId in answeredQuestions! {
                    if(actualId == self.id) {
                        return
                    }
                }
                answeredQuestions!.append(self.id)
            } else {
                answeredQuestions = [self.id]
            }

            defaults.setObject(answeredQuestions, forKey: "answeredQuestions")
        }
    }
    var id: Int
    var beacon: Beacon
    var answers: [Answer]
    var isSelectable: Bool
    
    init(text: String, id: Int, beacon: Beacon, answers: [Answer]) {
        self.text = text
        self.completed = false
        self.id = id
        self.beacon = beacon
        self.answers = answers
        self.isSelectable = false
    }
   
}
