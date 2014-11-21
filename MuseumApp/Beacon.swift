import UIKit

class Beacon: NSObject {
    var uuid: String
    var minor: String
    var major: String
    
    init(uuid: String, minor: String, major: String) {
        self.uuid = uuid
        self.minor = minor
        self.major = major
    }
   
}
