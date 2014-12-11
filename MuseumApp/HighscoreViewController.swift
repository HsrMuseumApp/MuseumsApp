
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
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
