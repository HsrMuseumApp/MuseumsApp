import UIKit

class TableViewCellUIView : UIView {
    
    override init() {
        super.init(frame: CGRect(x: 0.0, y: 0.0, width: 300 , height: 10))
        
        var label = UILabel(frame: CGRect.nullRect)
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.boldSystemFontOfSize(16)
        label.backgroundColor = UIColor.clearColor()
        label.frame = CGRect(x: 5.0, y: 5.0, width: 30.0, height: 30.0)
        label.text = "xxx"
        
        
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}