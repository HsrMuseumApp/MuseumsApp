
import UIKit

class HighscoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let kCellIdentifier: String = "playerCell"
    var highscores = [Highscore]()
    var pool = DataPool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if highscores.count == 0 {
            getHighscoreData()
            //tableView.reloadData()
        }
        
        tableView.dataSource = self
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getHighscoreData() {
        //var pool : DataPool = DataPool()
        pool.initializeDataPool()
        highscores = pool.highscoreArray
    }
    
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return highscores.count
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
            
            var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell
            
            var score: Highscore = highscores[indexPath.row]
            
            //let question:Question = questions[indexPath.row]
            //let beacon:CLBeacon? = getBeacon(question.beaconId)
            
            cell.textLabel.text = score.playerName + ": " + score.score.description
            
            
            return cell
    }
    
}
