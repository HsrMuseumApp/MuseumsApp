import UIKit

class Item: NSObject {
    var id: Int
    var name: String
    var questions: [Task]
    var beacons: [Beacon]
    
    init(id: Int, name: String, questions: [Task], beacons: [Beacon]) {
        self.id = id
        self.name = name
        self.questions = questions
        self.beacons = beacons
    }
}