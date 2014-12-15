import UIKit

protocol getScoreFromDetailDeleagte {
    func getScoreFromDetail(score:Int)
}

class TasksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TableViewCellDelegate, getScoreFromDetailDeleagte {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nav: UINavigationItem!
    
    var pool:DataPool?
    var tasks = [Task]()
    var task:Task?
    var locations = Dictionary<Int, Location>()
    var currentLocation = 1
    
    var score = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if tasks.count == 0 {
            showHelp()
            
            
        }
        
        checkIfQuestionsAnswered()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(TableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .None
        tableView.rowHeight = 50.0
        tableView.backgroundColor = UIColor.blackColor()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "saveDataPool", name: "kSaveDataPoolNotification", object: nil);

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    

    
    func initNavigationToolbarRooms() {
        nav.titleView = NavigationToolbar(bounds: CGRectGetWidth(self.view.bounds), pool: pool!, controller: self)
    }
    
    func changeTableContentForLocation(sender: UIBarButtonItem) {
        setLocationQuestions(sender.tag)
    }
    
    func setLocationQuestions(locId: Int) {
        currentLocation = locId
        var location : Location = locations[currentLocation]!
        tasks = location.questions
        tableView.reloadData()
    }
    
    func showHighScore() {
        self.performSegueWithIdentifier("showHighscore", sender: self)
    }
    
    func showHelp() {
        self.performSegueWithIdentifier("showIntro", sender: self)
    }
    
    func saveDataPool() {
        if (pool != nil) {
            let encodedPool = NSKeyedArchiver.archivedDataWithRootObject(pool!)
            NSUserDefaults.standardUserDefaults().setObject(encodedPool, forKey: "pool")
        }
        NSUserDefaults.standardUserDefaults().setInteger(score, forKey: "score")
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showHighscore") {
            var svc = segue.destinationViewController as HighscoreViewController
            svc.pool = self.pool!
            svc.score = score
            svc.highscores = self.pool!.highscoreArray
        } else if (segue.identifier == "showSubmitScore") {
            var svc = segue.destinationViewController as SubmitScoreViewController
            svc.score = score
            svc.highscores = self.pool!.highscoreArray
        } else if (segue.identifier == "showTaskDetail") {
            var svc = segue.destinationViewController as TaskDetailViewController
            svc.task = self.task
            svc.score = score
            svc.delegate = self
        }
    }
    
    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as TableViewCell
        cell.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = .None

        let task = tasks[indexPath.row]

        cell.delegate = self
        cell.task = task
        
        return cell
    }
    
    func taskAnswerQuestions(task: Task) {
        self.task = task
        self.performSegueWithIdentifier("showTaskDetail", sender: self)
    }
    
    // Mark: - Table view delegate
    func colorForIndex(index: Int) -> UIColor {
        return UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell,
        forRowAtIndexPath indexPath: NSIndexPath) {
            cell.backgroundColor = colorForIndex(indexPath.row)
    }

    
    func checkIfQuestionsAnswered() {
        var defaults = NSUserDefaults.standardUserDefaults()

        var completedTasks = defaults.objectForKey("completedTasks") as Dictionary<String,Int>!
        if(completedTasks != nil) {
            for task in tasks {
                for actualId in completedTasks!.keys {
                    if (actualId.toInt() == task.id) {
                        task.completed = true
                        task.selectedAnswer = completedTasks[actualId]!
                    }
                }
            }
        }
    }
    
    @IBAction func resetUserDefaults(sender: AnyObject) {
        if let tasks = self.pool?.tasks {
            for t in tasks.values {
                t.completed = false
                t.selectedAnswer = 0
            }
        }
        tableView.reloadData()
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(Dictionary<String,Int>(), forKey: "completedTasks")
        defaults.setInteger(0, forKey: "score")
        score = 0
    }
    
    func getScoreFromDetail(score: Int) {
        self.score = score
        submitScoreIfCompleted()
    }
    
    func submitScoreIfCompleted() {
        for task in pool!.taskArray {
            if (!task.completed) {
                return
            }
        }
        self.performSegueWithIdentifier("showSubmitScore", sender: self)
        
    }

}

