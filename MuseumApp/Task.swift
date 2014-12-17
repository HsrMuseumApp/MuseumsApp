import UIKit

class Task: NSObject, NSCoding {
    
    var text: String
    var desc: String
    var selectedAnswer: Int
    var completed: Bool {
        didSet {
            var defaults = NSUserDefaults.standardUserDefaults()
            var completedTasks = defaults.objectForKey("completedTasks") as Dictionary<String,Int>!
            if(completedTasks != nil) {
                for actualId in completedTasks!.keys {
                    if (actualId.toInt() == self.id) {
                        return
                        
                    }
                }
                completedTasks[String(self.id)] = selectedAnswer
            } else {
                completedTasks = Dictionary<String, Int>()
                completedTasks[String(self.id)] = selectedAnswer
            }
            defaults.setObject(completedTasks, forKey: "completedTasks")
        }
    }
    var id: Int
    var beacon: Beacon
    var answers: [Answer]
    var isSelectable: Bool
    var item: Item
    
    
    init(text: String, id: Int, desc: String, beacon: Beacon, answers: [Answer], item: Item) {
        self.text = text
        self.desc = desc
        self.completed = false
        self.id = id
        self.beacon = beacon
        self.answers = answers
        self.isSelectable = false
        self.selectedAnswer = 0
        self.item = item
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
        aCoder.encodeObject(item, forKey: "item")
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
        self.item = aDecoder.decodeObjectForKey("item") as Item
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
