import UIKit

class TaskDetailViewController: UIViewController {
    
    var task : Task?
    
    var selectedAnswer : Int?

    @IBOutlet weak var txtQuestion: UILabel!
    @IBOutlet weak var txtAnswerOne: UILabel!
    @IBOutlet weak var txtAnswerTwo: UILabel!
    @IBOutlet weak var txtAnswerThree: UILabel!
    
    @IBOutlet weak var errorMessage: UILabel!
    
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
        errorMessage.text = ""   
    }


    @IBAction func answerOnePressed(sender: AnyObject) {
        resetButton()
        btnAnswerOne.backgroundColor = UIColor.greenColor()
        self.selectedAnswer = 0
    }
    
    @IBAction func answerTwoPressed(sender: AnyObject) {
        resetButton()
        btnAnswerTwo.backgroundColor = UIColor.greenColor()
        self.selectedAnswer = 1
    }
    
    @IBAction func answerThreePressed(sender: AnyObject) {
        resetButton()
        btnAnswerThree.backgroundColor = UIColor.greenColor()
        self.selectedAnswer = 2
    }
    
    func resetButton() {
        btnAnswerOne.backgroundColor = UIColor.lightGrayColor()
        btnAnswerTwo.backgroundColor = UIColor.lightGrayColor()
        btnAnswerThree.backgroundColor = UIColor.lightGrayColor()
        
        btnSendAnswer.enabled = true
        btnSendAnswer.backgroundColor = UIColor.greenColor()
        errorMessage.text = ""
    }
    
    @IBAction func closeView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func sendAnswer(sender: AnyObject) {
        if(task!.answers[self.selectedAnswer!].correct) {
            task?.completed = true
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            errorMessage.text = "Falsche Antwort. Probiere es nochmals!"
        }
    }
}
