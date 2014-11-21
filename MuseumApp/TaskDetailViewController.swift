import UIKit

class TaskDetailViewController: UIViewController {
    
    var task : Task?

    override func viewDidLoad() {
        super.viewDidLoad()
        println(task!.questions)

    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
