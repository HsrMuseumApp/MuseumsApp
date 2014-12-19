import UIKit

class Item: NSObject, NSCoding {
    var id: Int
    var name: String
    var questions: [Task]?
    var beacons: [Beacon]?
    
    init(id: Int, name: String, questions: [Task], beacons: [Beacon]) {
        self.id = id
        self.name = name
        self.questions = questions
        self.beacons = beacons
    }
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(id, forKey: "id")
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(questions, forKey: "questions")
        aCoder.encodeObject(beacons, forKey: "beacons")
    }
    
    required init(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeIntegerForKey("id")
        self.name = aDecoder.decodeObjectForKey("name") as String
        self.questions = aDecoder.decodeObjectForKey("questions") as? [Task]
        self.beacons = aDecoder.decodeObjectForKey("beacons") as? [Beacon]
    }
}