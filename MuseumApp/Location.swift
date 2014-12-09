
import Foundation

class Location: NSObject {
    var id: Int
    var name: String
    var questions: [Task]
    
    init(id: Int, name: String, questions: [Task]) {
        self.id = id
        self.name = name
        self.questions = questions
    }
}