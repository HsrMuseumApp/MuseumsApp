import UIKit

class Task: NSObject, NSCoding {
    
    var text: String
    var desc: String
    var selectedAnswer: Int
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
    
    
    init(text: String, id: Int, desc: String, beacon: Beacon, answers: [Answer]) {
        self.text = text
        self.desc = desc
        self.completed = false
        self.id = id
        self.beacon = beacon
        self.answers = answers
        self.isSelectable = false
        self.selectedAnswer = 0
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(text, forKey: "text")
        aCoder.encodeObject(desc, forKey: "desc")
        aCoder.encodeBool(completed, forKey: "completed")
        aCoder.encodeInteger(id, forKey: "id")
        aCoder.encodeBool(isSelectable, forKey: "isSelectable")
        aCoder.encodeObject(beacon, forKey: "beacon")
        aCoder.encodeObject(answers, forKey: "answers")
        aCoder.encodeObject(selectedAnswer, forKey: "selectedAnswer")
    }
    
    required init(coder aDecoder: NSCoder) {
        self.text = aDecoder.decodeObjectForKey("text") as String
        self.desc = aDecoder.decodeObjectForKey("desc") as String
        self.selectedAnswer = aDecoder.decodeObjectForKey("selectedAnswer") as Int
        self.completed = aDecoder.decodeBoolForKey("completed")
        self.id = aDecoder.decodeIntegerForKey("id")
        self.isSelectable = aDecoder.decodeBoolForKey("isSelectable")
        self.beacon = aDecoder.decodeObjectForKey("beacon") as Beacon
        self.answers = aDecoder.decodeObjectForKey("answers") as [Answer]
    }
    
    func isCorrect() -> Bool {
        var isCorrect = false;
        if(selectedAnswer != 0) {
            for answer in answers {
                if(answer.correct) {
                    return answer.id == selectedAnswer
                }
            }
        }
        return isCorrect
    }
   
}
