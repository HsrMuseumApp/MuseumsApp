
import UIKit

class HighscoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let kCellIdentifier: String = "playerCell"
    var highscores = [Highscore]()
    var pool = DataPool()
    
    var score: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        highscores.sort({ $0.score > $1.score })
        
        self.title = "Dein Score: " + score!.description
        
        var submitButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        submitButton.setTitle("Submit", forState: UIControlState.Normal)
        submitButton.layer.frame = CGRect (x: CGRectGetWidth(self.view.bounds)-80, y: 12.0, width: 80.0, height: 20.0)
        submitButton.addTarget(self, action: Selector("submitScore"), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationController?.navigationBar.addSubview(submitButton)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func submitScore() {
        for task in pool.taskArray {
            if (!task.completed) {
                let controller = UIAlertController(title: "Fehler",
                    message: "Sie müssen zuerst alle Fragen beantworten um den Highscore hochzuladen!",
                    preferredStyle: .Alert)
                
                controller.addAction(UIAlertAction(title: "OK",
                    style: .Default,
                    handler: nil))
                
                presentViewController(controller, animated: true, completion: nil)
                return
            }
        }
        // TODO POST Request
    }
    
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return highscores.count
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
            var  cell:highscoreTableViewCell! = tableView.dequeueReusableCellWithIdentifier("highscoreTableViewCell") as? highscoreTableViewCell
            
            if (cell == nil)
            {
                let nib:Array = NSBundle.mainBundle().loadNibNamed("highscoreTableViewCell", owner: self, options: nil)
                cell = nib[0] as? highscoreTableViewCell
            }
            
            var score: Highscore = highscores[indexPath.row]
            
            cell.name.text = score.playerName
            cell.score.text = score.score.description
            
            return cell
    }
    
}
