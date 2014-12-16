
import UIKit
import QuartzCore

protocol TableViewCellDelegate {
    func taskAnswerQuestions(task: Task)
}

class TableViewCell: UITableViewCell {

    var originalCenter = CGPoint()
    let label : UILabel
    var answerImageView : UIImageView = UIImageView()
    let taskSelectableLayer = CALayer()
    var delegate: TableViewCellDelegate?
    var task: Task? {
        didSet {
            label.text = task!.text
            
            println("Question: \(task!.text) - Beacon: \(task!.beacon.major) - \(task!.beacon.minor) - \(task!.beacon.id)")
            
            
            if(task!.completed) {
                if(task!.isCorrect()) {
                    answerImageView.image = UIImage(named: "Tick.png");
                } else {
                    answerImageView.image = UIImage(named: "Error.png");
                }
            } else {
                answerImageView.image = nil
            }
            if(task!.isSelectable){
                taskSelectableLayer.hidden = false
            } else {
                taskSelectableLayer.hidden = true
            }
        }
    }
    let gradientLayer = CAGradientLayer()
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        label = UILabel(frame: CGRect.nullRect)
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.boldSystemFontOfSize(16)
        label.backgroundColor = UIColor.clearColor()
        
        // utility method for creating the contextual cues
        func createCueLabel() -> UILabel {
            let label = UILabel(frame: CGRect.nullRect)
            label.textColor = UIColor.whiteColor()
            label.font = UIFont.boldSystemFontOfSize(32.0)
            label.backgroundColor = UIColor.clearColor()
            return label
        }
        
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        answerImageView = UIImageView(frame: CGRectMake(CGRectGetWidth(bounds)-40, 10, 30, 30));
    
        addSubview(label)
        addSubview(answerImageView)
        
        selectionStyle = .None
        
        // gradient layer for cell
        gradientLayer.frame = bounds
        let color1 = UIColor(white: 1.0, alpha: 0.2).CGColor as CGColorRef
        let color2 = UIColor(white: 1.0, alpha: 0.1).CGColor as CGColorRef
        let color3 = UIColor.clearColor().CGColor as CGColorRef
        let color4 = UIColor(white: 0.0, alpha: 0.1).CGColor as CGColorRef
        gradientLayer.colors = [color1, color2, color3, color4]
        gradientLayer.locations = [0.0, 0.01, 0.95, 1.0]
        layer.insertSublayer(gradientLayer, atIndex: 0)
        
        taskSelectableLayer = CALayer(layer: layer)
        taskSelectableLayer.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.6, alpha: 1.0).CGColor
        taskSelectableLayer.hidden = true

        layer.insertSublayer(taskSelectableLayer, atIndex: 0)

        var recognizer = UITapGestureRecognizer(target:self, action: Selector("handleTap"))
        self.addGestureRecognizer(recognizer)
    }
    
    let kLabelLeftMargin: CGFloat = 15.0
    let kUICuesMargin: CGFloat = 10.0
    let kUICuesWidth: CGFloat = 50.0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        taskSelectableLayer.frame = bounds
        label.frame = CGRect(x: kLabelLeftMargin, y: 0, width: bounds.size.width - kLabelLeftMargin, height: bounds.size.height)
    }
    
 
    func handleTap() {
        if task != nil {
            //if(task!.isSelectable) { //TODO Enterfernen für BEACONS
                if(task!.answers.count > 0) {
                    delegate!.taskAnswerQuestions(task!)
                }
            //}
        }
    }
}
