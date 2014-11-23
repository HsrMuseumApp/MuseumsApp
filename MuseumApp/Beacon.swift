import UIKit

class Beacon: NSObject {
    var id : Int
    var minor: NSNumber
    var major: NSNumber
    
    init(id: Int, minor: NSNumber, major: NSNumber) {
        self.id = id
        self.minor = minor
        self.major = major
    }
   
}
