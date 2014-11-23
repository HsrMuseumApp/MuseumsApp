import Foundation

class DataPool {
    
    final var DB_SERVER = "http://152.96.56.11/group5/json/"
    final var QUESTIONS = "questions"
    
    var tasks = Dictionary<Int, Task>()
    var answers = Dictionary<Int, Answer>()
    var beacons = Dictionary<Int, Beacon>()
    
    func initializeDataPool() {
        
    }
    
    //func getAll
    
    
    func getAllQuestions() {
        var jsonObject: AnyObject = HttpConnect().HTTPGet(DB_SERVER + QUESTIONS)
        
        if let questionArray = jsonObject as? NSArray{
            if let aQuestion = questionArray[0] as? NSDictionary{
                if let userName = aQuestion["text"] as? String{
                    println(userName)
                }
            }
        }
        
        
    }
    
}
