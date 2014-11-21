import UIKit

class TaskDetailViewController: UIViewController {
    
    var task : Task?
    
    var selectedAnswer : Int?

    @IBOutlet weak var txtQuestion: UILabel!
    @IBOutlet weak var txtAnswerOne: UILabel!
    @IBOutlet weak var txtAnswerTwo: UILabel!
    @IBOutlet weak var txtAnswerThree: UILabel!
    
    @IBOutlet weak var btnAnswerOne: UIButton!
    @IBOutlet weak var btnAnswerTwo: UIButton!
    @IBOutlet weak var btnAnswerThree: UIButton!
    
    @IBOutlet weak var btnSendAnswer: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtQuestion.text = task!.text
        
        txtAnswerOne.text = task!.answers[0].text
        txtAnswerTwo.text = task!.answers[1].text
        txtAnswerThree.text = task!.answers[2].text
        
        btnSendAnswer.enabled = false
        
    }

    @IBAction func answerOnePressed(sender: AnyObject) {
        btnAnswerOne.backgroundColor = UIColor.greenColor()
        btnAnswerTwo.backgroundColor = UIColor.lightGrayColor()
        btnAnswerThree.backgroundColor = UIColor.lightGrayColor()
        
        self.selectedAnswer = 0
        btnSendAnswer.enabled = true
        btnSendAnswer.backgroundColor = UIColor.greenColor()
    }
    
    @IBAction func answerTwoPressed(sender: AnyObject) {
        btnAnswerOne.backgroundColor = UIColor.lightGrayColor()
        btnAnswerTwo.backgroundColor = UIColor.greenColor()
        btnAnswerThree.backgroundColor = UIColor.lightGrayColor()
        
        self.selectedAnswer = 1
        btnSendAnswer.enabled = true
        btnSendAnswer.backgroundColor = UIColor.greenColor()
    }
    
    @IBAction func answerThreePressed(sender: AnyObject) {
        btnAnswerOne.backgroundColor = UIColor.lightGrayColor()
        btnAnswerTwo.backgroundColor = UIColor.lightGrayColor()
        btnAnswerThree.backgroundColor = UIColor.greenColor()
        
        self.selectedAnswer = 2
        btnSendAnswer.enabled = true
        btnSendAnswer.backgroundColor = UIColor.greenColor()
    }
    
    @IBAction func closeView(sender: AnyObject) {
    }
    
    
    @IBAction func sendAnswer(sender: AnyObject) {
        if(task!.answers[self.selectedAnswer!].correct) {
            
        } else {
            
        }
        
    }
    
    
}
