
import UIKit
import QuartzCore

protocol TableViewCellDelegate {
    func taskAnswerQuestions(task: Task)
}

class TableViewCell: UITableViewCell {

    var originalCenter = CGPoint()
    let label : UILabel
    let subLabel : UILabel
    var answerImageView : UIImageView = UIImageView()
    let taskSelectableLayer = CALayer()
    var delegate: TableViewCellDelegate?
    var task: Task? {
        didSet {
            label.text = task!.desc
            subLabel.text = task!.item.name
            
            //println("S: \(task!.isSelectable) Question: \(task!.text) - Beacon: \(task!.beacon.major) - \(task!.beacon.minor) - \(task!.beacon.id)")
            
            
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
        label.textColor = UIColor( red: CGFloat(16/255.0), green: CGFloat(38/255.0), blue: CGFloat(64/255.0), alpha: CGFloat(1.0) )
        label.font = UIFont.boldSystemFontOfSize(16)
        label.backgroundColor = UIColor.clearColor()
        
        subLabel = UILabel(frame: CGRect.nullRect)
        subLabel.textColor = UIColor( red: CGFloat(16/255.0), green: CGFloat(38/255.0), blue: CGFloat(64/255.0), alpha: CGFloat(1.0) )
        subLabel.font = UIFont.systemFontOfSize(12)
        subLabel.backgroundColor = UIColor.clearColor()
        
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
        addSubview(subLabel)
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
        taskSelectableLayer.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0).CGColor
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
        label.frame = CGRect(x: kLabelLeftMargin, y: 0, width: bounds.size.width - kLabelLeftMargin, height: bounds.size.height/2)
        subLabel.frame = CGRect(x: kLabelLeftMargin, y: bounds.size.height/2, width: bounds.size.width - kLabelLeftMargin, height: bounds.size.height/2)
    }
    
 
    func handleTap() {
        if task != nil {
            if(task!.isSelectable || task!.completed) {
                if(task!.answers.count > 0) {
                    delegate!.taskAnswerQuestions(task!)
                }
            } else {
                var alert: UIAlertView = UIAlertView()
                alert.title = "Zu weit entfernt"
                alert.message = "Bitte begeben Sie sich zuerst in die Nähe des Gegenstandes \"" + task!.item.name + "\""
                alert.addButtonWithTitle("Ok")
                alert.show()
            }
        }
    }
}
