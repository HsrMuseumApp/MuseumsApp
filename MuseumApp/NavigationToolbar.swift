import UIKit

class NavigationToolbar : UIView {
    
    var controller: TasksViewController
    
    init(bounds: CGFloat, pool: DataPool, controller: TasksViewController) {
        self.controller = controller
        super.init(frame: CGRect(x: 0.0, y: 0.0, width: bounds , height: 40))        
        var pos_x = 0.0
        
        var helpButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        helpButton.setTitle("?", forState: UIControlState.Normal)
        helpButton.layer.frame = CGRect (x: bounds-45, y: 5.0, width: 30.0, height: 30.0)
        helpButton.titleLabel?.font = UIFont(name: "Futura-CondensedExtraBold", size: 25)
        
        helpButton.addTarget(controller, action: Selector("showHelp"), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(helpButton)
        
        if (pool.tasks.count > 0) {
            for index in Array(pool.locations.keys).sorted(<) {
                var loc = pool.locations[index]!
                var button = UIButton.buttonWithType(UIButtonType.System) as UIButton
                button.tag = loc.id
                
                button.setTitle(String(loc.id), forState: UIControlState.Normal)
                
                button.frame = CGRect(x: pos_x , y: 5.0, width: 35, height: 35)
                button.titleLabel?.font = UIFont(name: "Futura-CondensedExtraBold", size: 25)
                
                button.addTarget(controller, action: Selector("changeTableContentForLocation:"), forControlEvents: UIControlEvents.TouchUpInside)
                self.addSubview(button)
                pos_x += 32.0
            }
            
        }
        
        if (pool.highscores.count > 0) {
            var scoreButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
            var winnerpodium = UIImage(named:"winner-podium.png")
            
            scoreButton.layer.frame = CGRect (x: bounds-105, y: 2.0, width: 40.0, height: 40.0)
            scoreButton.setImage(winnerpodium, forState: UIControlState.Normal)
            scoreButton.contentVerticalAlignment = UIControlContentVerticalAlignment.Fill
            scoreButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Fill
            scoreButton.addTarget(controller, action: Selector("showHighScore"), forControlEvents: UIControlEvents.TouchUpInside)
            self.addSubview(scoreButton)
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}