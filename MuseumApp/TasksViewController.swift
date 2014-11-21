import UIKit

class TasksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TableViewCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var tasks = [Task]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if tasks.count > 0 {
            return
        }
        
        // Das sollte aus info.plist oder so geladen werden
        tasks.append(
            Task(
                text: "Dies ist die Frage 1",
                id: 1,
                beacon: Beacon(uuid: "abc", minor: "ab", major: "ab"),
                questions: [
                    Question(text: "Frage 1", correct: true),
                    Question(text: "Frage 2", correct: false),
                    Question(text: "Frage 3", correct: false)
                ]
            )
        )
        tasks.append(
            Task(
                text: "Dies ist die Frage 2",
                id: 2,
                beacon: Beacon(uuid: "abc", minor: "ab", major: "ab"),
                questions: []
            )
        )
        tasks.append(
            Task(
                text: "Dies ist die Frage 3",
                id: 3,
                beacon: Beacon(uuid: "abc", minor: "ab", major: "ab"),
                questions: [
                    Question(text: "Frage 1", correct: true),
                    Question(text: "Frage 2", correct: false),
                    Question(text: "Frage 3", correct: false)
                ]
            )
        )
        tasks.append(
            Task(
                text: "Dies ist die Frage 4",
                id: 4,
                beacon: Beacon(uuid: "abc", minor: "ab", major: "ab"),
                questions: []
            )
        )
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(TableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .None
        tableView.rowHeight = 50.0
        tableView.backgroundColor = UIColor.blackColor()
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
    
    func taskDeleted(task: Task) {
        let index = (tasks as NSArray).indexOfObject(task)
        if index == NSNotFound { return }
        
        // could removeAtIndex in the loop but keep it here for when indexOfObject works
        tasks.removeAtIndex(index)
        
        // use the UITableView to animate the removal of this row
        tableView.beginUpdates()
        let indexPathForRow = NSIndexPath(forRow: index, inSection: 0)
        tableView.deleteRowsAtIndexPaths([indexPathForRow], withRowAnimation: .Fade)
        tableView.endUpdates()    
    }
    
    func taskCompleted(task: Task) {
        
    }
    
    func taskAnswerQuestions(task: Task) {
        let taskDetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TaskDetailViewController") as TaskDetailViewController
        taskDetailViewController.task = task
        self.presentViewController(taskDetailViewController, animated: true, completion: nil)
    }
    
    // Mark: - Table view delegate
    func colorForIndex(index: Int) -> UIColor {
        let taskCount = tasks.count - 1
        let val = (CGFloat(index) / CGFloat(taskCount)) * 0.6 + 0.3
        return UIColor(red: 0.4, green: val, blue: 1.0, alpha: 1.0)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell,
        forRowAtIndexPath indexPath: NSIndexPath) {
            cell.backgroundColor = colorForIndex(indexPath.row)
    }



}

