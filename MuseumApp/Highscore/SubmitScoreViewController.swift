import UIKit

class SubmitScoreViewController: UIViewController {

    
    @IBOutlet weak var infoText: UITextView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var btnSend: UIButton!
    
    var score:Int?
    var highscores = [Highscore]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let highestScore:Int = NSUserDefaults.standardUserDefaults().valueForKey("highestScore") as? Int {
            if (highestScore >= score) {
                infoText.text = "Du hast alle Fragen beantwortet und " + score!.description + " Punkte erreicht. Dein persönlicher Rekord liegt bei " + highestScore.description + " Punkten. Versuche es nochmals um diesen zu knacken."
                labelName.hidden = true
                name.hidden = true
                btnSend.hidden = true
            } else {
                infoText.text = "Du hast alle Fragen beantwortet und einen neuen Punkterekord erreicht. Deine erreichte Punkte sind " + score!.description + ". Dein bisheriger Rekord lag bei " + highestScore.description + " Punkten. Wähle einen Namen und drücke Senden, wenn du deinen Rekord auf dem Leaderboard speichern möchtest."
            }
        } else {
            infoText.text = "Du hast alle Fragen beantwortet. und " + score!.description + " Punkte erreicht. Wähle einen Namen und drücke Senden, wenn du deinen Rekord auf dem Leaderboard speichern möchtest."
        }
        
        if let playerName:String = NSUserDefaults.standardUserDefaults().valueForKey("playerName") as? String {
            name.text = playerName
        }
        
        
    }
    
    @IBAction func btnSendPressed(sender: UIButton) {
        
        if (name.text == "") {
            let controller = UIAlertController(title: "Name",
                message: "Bitte wähle einen Namen, mit welchem du auf dem Leaderboard erscheinen möchtest.",
                preferredStyle: .Alert)
            
            controller.addAction(UIAlertAction(title: "OK",
                style: .Default,
                handler: nil))
            presentViewController(controller, animated: true, completion: nil)
        } else {
            if let playerName:String = NSUserDefaults.standardUserDefaults().valueForKey("playerName") as? String{
                if (playerName != name.text) {
                    // TODO delete record with name of var playerName in db (API doesn't support deletion)
                } else {
                    // TODO delete record with name of field name in db (API doesn't support deletion)
                }
            }
            
            NSUserDefaults.standardUserDefaults().setInteger(score!, forKey: "highestScore")
            NSUserDefaults.standardUserDefaults().setObject(name.text, forKey: "playerName")
        }
        
        // TODO POST Request
    }

}