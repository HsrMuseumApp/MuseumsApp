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
    
    var score: Int?
    
    var delegate:getScoreFromDetailDeleagte?
    
    var btnArray:[UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtQuestion.text = task!.text
        
        txtAnswerOne.text = task!.answers[0].text
        txtAnswerTwo.text = task!.answers[1].text
        txtAnswerThree.text = task!.answers[2].text

        errorMessage.text = ""
        
        btnArray = [self.btnAnswerOne, btnAnswerTwo, btnAnswerThree]
        
        if(task!.completed) {
            for btn in btnArray {
                btn.enabled = false
            }
            for var i = 0; i < task!.answers.count; ++i {
                if(task!.answers[i].id == task?.selectedAnswer) {
                    self.selectedAnswer = i
                }
            }
            if(task!.isCorrect()){
                setAnswerCorrect()
            } else {
                setAnswerIncorrect()
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        delegate?.getScoreFromDetail(score!)
    }


    @IBAction func answerOnePressed(sender: AnyObject) {
        self.selectedAnswer = 0
        checkAnswer()
    }
    
    @IBAction func answerTwoPressed(sender: AnyObject) {
        self.selectedAnswer = 1
        checkAnswer()
    }
    
    @IBAction func answerThreePressed(sender: AnyObject) {
        self.selectedAnswer = 2
        checkAnswer()
    }
    
    func checkAnswer() {
        task?.completed = true
        
        for btn in btnArray {
            btn.enabled = false
        }
        
        if(task!.answers[self.selectedAnswer!].correct) {
            setAnswerCorrect()
            score!++
            
        } else {
            setAnswerIncorrect()
            if (score > 0) {
                score!--
            }
        }
        task?.selectedAnswer = task!.answers[self.selectedAnswer!].id
        delegate?.getScoreFromDetail(score!)
    }
    
    func setAnswerCorrect() {
        var btnSelected:UIButton = self.btnArray[selectedAnswer!]
        btnSelected.backgroundColor = UIColor.greenColor()
        errorMessage.text = "Korrekt, weiter gehts!"
    }
    
    func setAnswerIncorrect() {
        errorMessage.text = "Leider falsch, versuchs mit der nächsten Frage!"
        
        var btnSelected:UIButton = self.btnArray[selectedAnswer!]
        btnSelected.backgroundColor = UIColor.redColor()
        
        var i = 0
        for answer in task!.answers {
            if answer.correct {
                var btnCorrect:UIButton = self.btnArray[i]
                btnCorrect.backgroundColor = UIColor.greenColor()
            }
            i++
        }
    }
    
}
