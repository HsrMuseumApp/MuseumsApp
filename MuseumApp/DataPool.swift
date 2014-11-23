import Foundation

class DataPool {
    
    final var DB_SERVER = "http://152.96.56.11/group5/json/"
    final var QUESTIONS = "questions"
    final var BEACONS = "beacons"
    final var ITEMS = "items"
    final var ANSWERS = "answers"
    
    var tasks = Dictionary<Int, Task>()
    var taskArray = [Task]()
    var beacons = Dictionary<String, Beacon>()
    var items = Dictionary<Int, Item>()
    
    func initializeDataPool() {
        getAllBeacons()
        getAllQuestions()
        taskArray = tasks.values.array
    }
    
    func getAllQuestions() {
        var jsonObject: AnyObject = HttpConnect().HTTPGet(DB_SERVER + QUESTIONS)
        
        if let questionArray = jsonObject as? NSArray{
            for var i = 0; i < questionArray.count; ++i {
                if let jsonQuestion = questionArray[i] as? NSDictionary{
                    let id = jsonQuestion["id"] as? Int
                    let text = jsonQuestion["text"] as? String
                    let itemId = jsonQuestion["itemId"] as? Int
                    var answers: [Answer] = getAnswerFromQuestion(id!)
                    var beacons: [Beacon] = getBeaconsByItemId(itemId!)
                    var task = Task(text: text!, id: id!, beacon: beacons[0], answers: answers)
                    tasks[id!] = task
                }
            }
        }
    }
    
    func getAnswerFromQuestion(id: Int) -> [Answer]  {
        var jsonObject: AnyObject = HttpConnect().HTTPGet("\(DB_SERVER)\(QUESTIONS)/\(id)/\(ANSWERS)")
        var answers = [Answer]()
        
        if let answerArray = jsonObject as? NSArray{
            for var i = 0; i < answerArray.count; ++i {
                if let jsonAnswer = answerArray[i] as? NSDictionary{
                    let id = jsonAnswer["id"] as? Int
                    let text = jsonAnswer["text"] as? String
                    let correct = jsonAnswer["correct"] as? Bool
                    var answer : Answer = Answer(id: id!, text: text!, correct: correct!)
                    answers.append(answer)
                }
            }
        }
        return answers
    }
    
    func getBeaconsByItemId(id: Int) -> [Beacon] {
        var jsonObject: AnyObject = HttpConnect().HTTPGet("\(DB_SERVER)\(ITEMS)/\(id)/\(BEACONS)")
        var beaconsArr = [Beacon]()
        
        if let beaconArray = jsonObject as? NSArray{
            for var i = 0; i < beaconArray.count; ++i {
                if let jsonBeacon = beaconArray[i] as? NSDictionary{
                    let id = jsonBeacon["beaconId"] as? String
                    var beacon : Beacon = beacons[id!]!
                    beaconsArr.append(beacon)
                }
            }
        }
        return beaconsArr
    }
    
    
    func getAllBeacons() {
        var jsonObject: AnyObject = HttpConnect().HTTPGet(DB_SERVER + BEACONS)
        if let beaconArray = jsonObject as? NSArray{
            for var i = 0; i < beaconArray.count; ++i {
                if let jsonBeacon = beaconArray[i] as? NSDictionary{
                    let beaconId = jsonBeacon["beaconId"] as? String
                    let minor = jsonBeacon["minor"] as? NSNumber
                    let major = jsonBeacon["major"] as? NSNumber
                    var beacon: Beacon = Beacon(id: beaconId!, minor: minor!, major: major!)
                    beacons[beaconId!] = beacon
                }
            }
        }
    }
    
    func getAllItems() {
        var jsonObject: AnyObject = HttpConnect().HTTPGet(DB_SERVER + ITEMS)
        if let itemArray = jsonObject as? NSArray{
            for var i = 0; i < itemArray.count; ++i {
                if let jsonItem = itemArray[i] as? NSDictionary{
                    let id = jsonItem["id"] as? Int
                    //var item: Item = Beacon(id: beaconId!, minor: minor!, major: major!)
                    //items[id] = item
                }
            }
        }
    }
    
}
