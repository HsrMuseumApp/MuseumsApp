import UIKit

class TasksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TableViewCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    
    var tasks = [Task]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if tasks.count > 0 {
            return
        }
        
        setupData()
        
        checkIfQuestionsAnswered()
        
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
    
    func setupData() {
        tasks.append(
            Task(
                text: "Ist Robin der beste Programmierer?",
                id: 1,
                beacon: Beacon(minor: 18479, major: 56048),
                answers: [
                    Answer(text: "Ja", correct: true),
                    Answer(text: "Nein", correct: false),
                    Answer(text: "Nein", correct: false)
                ]
            )
        )
        tasks.append(
            Task(
                text: "Dies ist die Frage 2",
                id: 2,
                beacon: Beacon(minor: 1, major: 2),
                answers: []
            )
        )
        tasks.append(
            Task(
                text: "Welches ist Robins Lieblingsfarbe",
                id: 3,
                beacon: Beacon(minor: 1, major: 2),
                answers: [
                    Answer(text: "Blau", correct: true),
                    Answer(text: "Rot", correct: false),
                    Answer(text: "Grün", correct: false)
                ]
            )
        )
        tasks.append(
            Task(
                text: "Dies ist die Frage 4",
                id: 4,
                beacon: Beacon(minor: 1, major: 2),
                answers: []
            )
        )
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

