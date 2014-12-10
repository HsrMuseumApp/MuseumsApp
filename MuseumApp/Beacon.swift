import UIKit

class Beacon: NSObject, NSCoding {
    var id : String
    var minor: Int
    var major: Int
    
    init(id: String, minor: Int, major: Int) {
        self.id = id
        self.minor = minor
        self.major = major
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(id, forKey: "id")
        aCoder.encodeInteger(minor, forKey: "minor")
        aCoder.encodeInteger(major, forKey: "major")
    }
    
    required init(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObjectForKey("id") as String
        self.minor = aDecoder.decodeIntegerForKey("minor")
        self.major = aDecoder.decodeIntegerForKey("major")
    }
   
}
