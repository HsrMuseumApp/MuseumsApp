
import UIKit
import QuartzCore

protocol TableViewCellDelegate {
    func taskAnswerQuestions(task: Task)
}

class TableViewCell: UITableViewCell {

    var originalCenter = CGPoint()
    var tickLabel: UILabel
    var questionLabel: UILabel
    var completeOnDragRelease = false
    let label: StrikeThroughText
    let taskCompleteLayer = CALayer()
    let taskSelectableLayer = CALayer()
    var delegate: TableViewCellDelegate?
    var task: Task? {
        didSet {
            label.text = task!.text
            label.strikeThrough = task!.completed
            if(task!.completed) {
                    label.strikeThrough = true
                    taskCompleteLayer.hidden = false
            } else if(task!.isSelectable){
                taskSelectableLayer.hidden = false
            }
        
            if(task?.answers.count > 0) {
                addSubview(questionLabel)
            } else {
                addSubview(tickLabel)
            }
        }
    }
    let gradientLayer = CAGradientLayer()
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        label = StrikeThroughText(frame: CGRect.nullRect)
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
        
        // tick and question labels for context cues
        tickLabel = createCueLabel()
        tickLabel.text = "\u{2713}"
        tickLabel.textAlignment = .Right
        
        questionLabel = createCueLabel()
        questionLabel.text = "?"
        questionLabel.textAlignment = .Right
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(label)

        
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
        
        taskCompleteLayer = CALayer(layer: layer)
        taskCompleteLayer.backgroundColor = UIColor(red: 0.0, green: 0.6, blue: 0.0, alpha: 1.0).CGColor
        taskCompleteLayer.hidden = true
        
        taskSelectableLayer = CALayer(layer: layer)
        taskSelectableLayer.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.6, alpha: 1.0).CGColor
        taskSelectableLayer.hidden = true
        
        layer.insertSublayer(taskCompleteLayer, atIndex: 0)
        layer.insertSublayer(taskSelectableLayer, atIndex: 0)
        
        var recognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
        recognizer.delegate = self
        addGestureRecognizer(recognizer)
    }
    
    let kLabelLeftMargin: CGFloat = 15.0
    let kUICuesMargin: CGFloat = 10.0
    let kUICuesWidth: CGFloat = 50.0
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        taskCompleteLayer.frame = bounds
        taskSelectableLayer.frame = bounds
        
        label.frame = CGRect(x: kLabelLeftMargin, y: 0, width: bounds.size.width - kLabelLeftMargin, height: bounds.size.height)
        
        tickLabel.frame = CGRect(x: -kUICuesWidth - kUICuesMargin, y: 0, width: kUICuesWidth, height: bounds.size.height)
        questionLabel.frame = CGRect(x: -kUICuesWidth - kUICuesMargin, y: 0, width: kUICuesWidth, height: bounds.size.height)
    }
    
    //MARK: - horizontal pan gesture methods
    func handlePan(recognizer: UIPanGestureRecognizer) {

        if recognizer.state == .Began {
            originalCenter = center
        }

        if recognizer.state == .Changed {
            let translation = recognizer.translationInView(self)
            center = CGPointMake(originalCenter.x + translation.x, originalCenter.y)
            completeOnDragRelease = frame.origin.x > frame.size.width / 2.0
            
            // fade the contextual clues
            let cueAlpha = fabs(frame.origin.x) / (frame.size.width / 2.0)
            tickLabel.alpha = cueAlpha
            questionLabel.alpha = cueAlpha
            // indicate when the user has pulled the item far enough to invoke the given action
            tickLabel.textColor = completeOnDragRelease ? UIColor.greenColor() : UIColor.whiteColor()
            questionLabel.textColor = completeOnDragRelease ? UIColor.yellowColor() : UIColor.whiteColor()
        }

        if recognizer.state == .Ended {
            let originalFrame = CGRect(x: 0, y: frame.origin.y,
                width: bounds.size.width, height: bounds.size.height)
            if completeOnDragRelease {
                if task != nil {
                    if(task!.isSelectable) {
                        if(task!.answers.count > 0) {
                            if(!task!.completed) {
                                delegate!.taskAnswerQuestions(task!)
                            }
                        } else {
                            label.strikeThrough = true
                            taskCompleteLayer.hidden = false
                            task!.completed = true
                        }
                    }
                    UIView.animateWithDuration(0.2, animations: {self.frame = originalFrame})
                }
            } else {
                UIView.animateWithDuration(0.2, animations: {self.frame = originalFrame})
            }
        }
    }
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translationInView(superview!)
            if fabs(translation.x) > fabs(translation.y) {
                return true
            }
            return false
        }
        return false
    }
}
