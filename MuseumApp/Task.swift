import UIKit

class Task: NSObject, NSCoding {
    
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
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(text, forKey: "text")
        aCoder.encodeBool(completed, forKey: "completed")
        aCoder.encodeInteger(id, forKey: "id")
        aCoder.encodeBool(isSelectable, forKey: "isSelectable")
        aCoder.encodeObject(beacon, forKey: "beacon")
        aCoder.encodeObject(answers, forKey: "answers")
    }
    
    required init(coder aDecoder: NSCoder) {
        self.text = aDecoder.decodeObjectForKey("text") as String
        self.completed = aDecoder.decodeBoolForKey("completed")
        self.id = aDecoder.decodeIntegerForKey("id")
        self.isSelectable = aDecoder.decodeBoolForKey("isSelectable")
        self.beacon = aDecoder.decodeObjectForKey("beacon") as Beacon
        self.answers = aDecoder.decodeObjectForKey("answers") as [Answer]
        //var encodedBeacon = aDecoder.decodeObjectForKey("beacon") as NSData
        //self.beacon = NSKeyedUnarchiver.unarchiveObjectWithData(encodedBeacon) as Beacon
        
        //var encodedAnswerArray = aDecoder.decodeObjectForKey("answers") as [NSData]
        //self.answers = [Answer]()
        //for encodedAnswer in encodedAnswerArray {
        //    var answer = NSKeyedUnarchiver.unarchiveObjectWithData(encodedAnswer) as Answer
        //    answers.append(answer)
        //}
    }
   
}
