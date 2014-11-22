import UIKit

class Beacon: NSObject {
    var minor: NSNumber
    var major: NSNumber
    
    init(minor: NSNumber, major: NSNumber) {
        self.minor = minor
        self.major = major
    }
   
}
