import Foundation

class DataPool : NSObject, NSCoding {
    
    final var DB_SERVER = NSBundle.mainBundle().objectForInfoDictionaryKey("serverUrl") as String
    final var QUESTIONS = "questions"
    final var BEACONS = "beacons"
    final var ITEMS = "items"
    final var ANSWERS = "answers"
    final var LOCATIONS = "locations"
    final var HIGHSCORES = "highscores"
    
    var tasks = Dictionary<Int, Task>()
    var taskArray = [Task]()
    var beacons = Dictionary<String, Beacon>()
    var items = Dictionary<Int, Item>()
    var locations = Dictionary<Int, Location>()
    var highscores = Dictionary<Int, Highscore>()
    var highscoreArray = [Highscore]()
    var locationArray = [Location]()
    
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(tasks, forKey: "tasks")
        aCoder.encodeObject(beacons, forKey: "beacons")
        aCoder.encodeObject(items, forKey: "items")
        aCoder.encodeObject(locations, forKey: "locations")
        aCoder.encodeObject(highscores, forKey: "highscores")
    }
    
    required init(coder aDecoder: NSCoder) {
        tasks = aDecoder.decodeObjectForKey("tasks") as Dictionary<Int, Task>
        taskArray = tasks.values.array
        beacons = aDecoder.decodeObjectForKey("beacons") as Dictionary<String, Beacon>
        items = aDecoder.decodeObjectForKey("items") as Dictionary<Int, Item>
        locations = aDecoder.decodeObjectForKey("locations") as Dictionary<Int, Location>
        locationArray = locations.values.array
        highscores = aDecoder.decodeObjectForKey("highscores") as Dictionary<Int, Highscore>
        highscoreArray = highscores.values.array

    }
    
    override init() {
        
    }
    
    func initializeDataPool() {
        getAllItems()
        getAllBeacons()
        getAllQuestions()
        getAllLocations()
        getAllHighscores()
        taskArray = tasks.values.array
        locationArray = locations.values.array
        highscoreArray = highscores.values.array
        
        var completedTasks = NSUserDefaults.standardUserDefaults().objectForKey("completedTasks") as Dictionary<String,Int>!
        if(completedTasks != nil) {
            for task in taskArray {
                for actualId in completedTasks!.keys {
                    if (actualId.toInt() == task.id) {
                        task.completed = true
                        task.selectedAnswer = completedTasks[actualId]!
                    }
                }
            }
        }
        
        let encodedPool = NSKeyedArchiver.archivedDataWithRootObject(self)
        NSUserDefaults.standardUserDefaults().setObject(encodedPool, forKey: "pool")
    }
    
    func loadFromSavedData() {
        var pool = NSUserDefaults.standardUserDefaults().objectForKey("pool") as NSData

        var dataPool = NSKeyedUnarchiver.unarchiveObjectWithData(pool) as DataPool
        self.taskArray = dataPool.taskArray
    }
    
    func getAllItems() {
        var jsonObject: AnyObject = HttpConnect().HTTPGet(DB_SERVER + ITEMS)
        
        if let itemsArray = jsonObject as? NSArray{
            for var i = 0; i < itemsArray.count; ++i {
                if let jsonItem = itemsArray[i] as? NSDictionary{
                    let id = jsonItem["id"] as Int
                    let name = jsonItem["name"] as String
                    
                    var item = Item(id: id, name: name)
                    items[id] = item
                }
            }
        }
    }
    
    func getAllQuestions() {
        var jsonObject: AnyObject = HttpConnect().HTTPGet(DB_SERVER + QUESTIONS)
        
        if let questionArray = jsonObject as? NSArray{
            for var i = 0; i < questionArray.count; ++i {
                if let jsonQuestion = questionArray[i] as? NSDictionary{
                    let id = jsonQuestion["id"] as? Int
                    let text = jsonQuestion["text"] as? String
                    let desc = jsonQuestion["description"] as? String
                    let itemId = jsonQuestion["itemId"] as? Int
                    var answers: [Answer] = getAnswerFromQuestion(id!)
                    var beacons: [Beacon] = getBeaconsByItemId(itemId!)
                    var item: Item = items[itemId!]!
                    var task = Task(text: text!, id: id!, desc: desc!, beacon: beacons[0], answers: answers, item: item)
                    tasks[id!] = task
                }
            }
        }
    }
    

    
    
    func getAllBeacons() {
        var jsonObject: AnyObject = HttpConnect().HTTPGet(DB_SERVER + BEACONS)
        if let beaconArray = jsonObject as? NSArray{
            for var i = 0; i < beaconArray.count; ++i {
                if let jsonBeacon = beaconArray[i] as? NSDictionary{
                    let beaconId = jsonBeacon["beaconId"] as? String
                    let minor = jsonBeacon["minor"] as? Int
                    let major = jsonBeacon["major"] as? Int
                    var beacon: Beacon = Beacon(id: beaconId!, minor: minor!, major: major!)
                    beacons[beaconId!] = beacon
                }
            }
        }
    }
    
    func getAllLocations() {
        var jsonObject: AnyObject = HttpConnect().HTTPGet(DB_SERVER + LOCATIONS)
        if let locationArray = jsonObject as? NSArray{
            for var i = 0; i < locationArray.count; ++i {
                if let jsonLocation = locationArray[i] as? NSDictionary{
                    let id = jsonLocation["id"] as? Int
                    let name = jsonLocation["name"] as? String
                    let itemIdArray = jsonLocation["items"] as? [Int]
                    var questionArray : [Task] = getQuestionsFromItems(itemIdArray!)
                    var location: Location = Location(id: id!, name: name!, questions: questionArray)
                    locations[id!] = location
                }
            }
        }
    }
    
    func getAllHighscores() {
        var jsonObject: AnyObject = HttpConnect().HTTPGet(DB_SERVER + HIGHSCORES)
        if let highscoreArray = jsonObject as? NSArray{
            for var i = 0; i < highscoreArray.count; ++i {
                if let jsonHighscore = highscoreArray[i] as? NSDictionary{
                    let groupId = jsonHighscore["groupId"] as Int
                    let score = jsonHighscore["score"] as Int
                    let playerName = jsonHighscore["playerName"] as String
                    let rank = jsonHighscore["rank"] as Int
                    let hash = jsonHighscore["hash"] as? String
                    var highscore: Highscore = Highscore(groupId: groupId, score: score, playerName: playerName, rank: rank, hashStr: hash)
                    highscores[rank] = highscore
                    
                }
            }
        }
    }
    
    func getQuestionsFromItems(itemIdArray: [Int]) -> [Task] {
        var questionArray = [Task]()
        
        for itemId in itemIdArray {
            questionArray += getQuestionsFromItemId(itemId)
        }
        return questionArray
    }
    
    func getQuestionsFromItemId(itemId: Int) -> [Task] {
        var questionsArray = [Task]()
        
        var jsonObject: AnyObject = HttpConnect().HTTPGet("\(DB_SERVER)\(ITEMS)/\(itemId)/\(QUESTIONS)")
        if let questionArray = jsonObject as? NSArray{
            for var i = 0; i < questionArray.count; ++i {
                if let jsonQuestion = questionArray[i] as? NSDictionary{
                    let id = jsonQuestion["id"] as? Int
                    questionsArray.append(tasks[id!]!)
                }
            }
        }
        return questionsArray
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

    func hasAnsweredQuestions() -> Bool {
        for task in taskArray {
            if task.completed == true {
                return true
            }
        }
        return false
    }
    
}
