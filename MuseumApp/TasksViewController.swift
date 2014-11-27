import UIKit

class TasksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TableViewCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nav: UINavigationItem!
    
    var pool = DataPool()
    var tasks = [Task]()
    var locations = Dictionary<Int, Location>()
    var currentLocation = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if tasks.count > 0 {
            return
        }
        
        pool.initializeDataPool()
        locations = pool.locations
        setLocationQuestions(currentLocation)
        
        checkIfQuestionsAnswered()
        initNavigationToolbar()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(TableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .None
        tableView.rowHeight = 50.0
        tableView.backgroundColor = UIColor.blackColor()
        

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    func initNavigationToolbar() {
        var barb = UIBarButtonItem()
        var buttonArray = [UIBarButtonItem]()
        var flex = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        buttonArray.append(flex)
        
        let sortedKeys = Array(locations.keys).sorted(<)
        for index in sortedKeys {
            var loc = locations[index]!
            var button = UIBarButtonItem(title: String(loc.id), style: .Plain, target: self, action: Selector("changeTableContentForLocation:"))
            button.tag = loc.id
            buttonArray.append(button)
        }
        buttonArray.append(flex)
        nav.setLeftBarButtonItems(buttonArray, animated: true)
        
        var highsc = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Bookmarks, target: nil, action: Selector("showHighScore"))
        var winnerpodium = UIImage(named:"winner-podium.png")
        //winnerpodium?.resizingMode = UIImageResizingMode.Tile
        var highScoreButton = UIBarButtonItem(image: winnerpodium, style: .Bordered, target: self, action: Selector("showHighScore"))
        highScoreButton.imageInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        //var x = UIBarButtonItem(image: <#UIImage?#>, style: UIBarButtonItemStyle.RawValue, target: <#AnyObject?#>, action: <#Selector#>)
        nav.setRightBarButtonItem(highScoreButton, animated: false)
        
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
        println("SHOOOW HIGHSCOREEE")
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
        println("reset ausgeführt")
        for task in self.tasks {
            task.completed = false
        }
        tableView.reloadData()
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject([], forKey: "answeredQuestions")
    }

}

