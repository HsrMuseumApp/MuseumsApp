import UIKit

class Answer: NSObject, NSCoding {
    var id: Int
    var text: String
    var correct: Bool
    
    init(id: Int, text: String, correct: Bool) {
        self.id = id
        self.text = text
        self.correct = correct
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(id, forKey: "id")
        aCoder.encodeObject(text, forKey: "text")
        aCoder.encodeBool(correct, forKey: "correct")
    }
    
    required init(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeIntegerForKey("id")
        self.text = aDecoder.decodeObjectForKey("text") as String
        self.correct = aDecoder.decodeBoolForKey("major")
    }
}
