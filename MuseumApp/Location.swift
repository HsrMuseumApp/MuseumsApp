
import Foundation

class Location: NSObject, NSCoding {
    var id: Int
    var name: String
    var questions: [Task]
    
    init(id: Int, name: String, questions: [Task]) {
        self.id = id
        self.name = name
        self.questions = questions
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(id, forKey: "id")
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(questions, forKey: "questions")
    }
    
    required init(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeIntegerForKey("id")
        self.name = aDecoder.decodeObjectForKey("name") as String
        self.questions = aDecoder.decodeObjectForKey("questions") as [Task]
    }
}