import Foundation

class DataPool {
    
    final var DB_SERVER = "http://152.96.56.11/group5/json/"
    final var QUESTIONS = "questions"
    
    
    
    func getAllQuestions() {
        println(HttpConnect().HTTPGet(DB_SERVER+QUESTIONS))
    }
    
}
