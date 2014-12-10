import UIKit

protocol getScoreFromDetailDeleagte {
    func getScoreFromDetail(score:Int)
}

class TasksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TableViewCellDelegate, getScoreFromDetailDeleagte {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nav: UINavigationItem!
    
    var pool:DataPool?
    var tasks = [Task]()
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
        
        var cview = UIView()
        cview.frame = CGRect(x: 0.0, y: 0.0, width: CGRectGetWidth(self.view.bounds) , height: 40)
        var pos_x = 10.0
        
        var helpButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        helpButton.setTitle("?", forState: UIControlState.Normal)
        helpButton.layer.frame = CGRect (x: CGRectGetWidth(self.view.bounds)-40, y: 5.0, width: 20.0, height: 20.0)
        helpButton.layer.borderColor = UIColor.blackColor().CGColor
        helpButton.layer.cornerRadius = 0.5 * helpButton.bounds.size.width
        helpButton.layer.borderWidth = 0.5
        helpButton.addTarget(self, action: Selector("showHelp"), forControlEvents: UIControlEvents.TouchUpInside)
        cview.addSubview(helpButton)
        
        if (tasks.count > 0) {
            for index in Array(locations.keys).sorted(<) {
                var loc = locations[index]!
                var button = UIButton.buttonWithType(UIButtonType.System) as UIButton
                button.tag = loc.id

                button.setTitle(String(loc.id), forState: UIControlState.Normal)
                
                button.frame = CGRect(x: pos_x , y: 5.0, width: 20, height: 20)
                button.layer.borderColor = UIColor.blackColor().CGColor
                button.layer.cornerRadius = 0.5 * button.bounds.size.width
                button.layer.borderWidth = 0.5
                button.layer.frame = CGRect (x: pos_x, y: 5.0, width: 20.0, height: 20.0)
                
                button.addTarget(self, action: Selector("changeTableContentForLocation:"), forControlEvents: UIControlEvents.TouchUpInside)
                cview.addSubview(button)
                pos_x += 25.0
            }
            
            
        }
        
        if (pool?.highscores.count > 0) {
            var scoreButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
            var winnerpodium = UIImage(named:"winner-podium.png")
            scoreButton.setImage(winnerpodium, forState: UIControlState.Normal)
            scoreButton.layer.frame = CGRect (x: CGRectGetWidth(self.view.bounds)-80, y: 5.0, width: 20.0, height: 20.0)
            scoreButton.layer.borderColor = UIColor.blackColor().CGColor
            scoreButton.layer.cornerRadius = 0.5 * helpButton.bounds.size.width
            scoreButton.layer.borderWidth = 0.5
            scoreButton.addTarget(self, action: Selector("showHighScore"), forControlEvents: UIControlEvents.TouchUpInside)
            cview.addSubview(scoreButton)
        }
        
 
        nav.titleView = cview
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
        let taskDetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TaskDetailViewController") as TaskDetailViewController
        taskDetailViewController.task = task
        taskDetailViewController.score = score
        taskDetailViewController.delegate = self
        self.presentViewController(taskDetailViewController, animated: true, completion: nil)
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
        var answeredQuestions: [Int]? = defaults.objectForKey("answeredQuestions") as [Int]?
        if(answeredQuestions != nil) {
            for task in tasks {
                for actualId in answeredQuestions! {
                    if(actualId == task.id) {
                        task.completed = true
                    }
                }
            }
        }
    }
    
    @IBAction func resetUserDefaults(sender: AnyObject) {
        for task in self.tasks {
            task.completed = false
        }
        tableView.reloadData()
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject([], forKey: "answeredQuestions")
        defaults.setInteger(0, forKey: "score")
        score = 0
    }
    
    func getScoreFromDetail(score: Int) {
        self.score = score
    }

}

