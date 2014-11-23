import UIKit

class Beacon: NSObject {
    var id : String
    var minor: NSNumber
    var major: NSNumber
    
    init(id: String, minor: NSNumber, major: NSNumber) {
        self.id = id
        self.minor = minor
        self.major = major
    }
   
}
