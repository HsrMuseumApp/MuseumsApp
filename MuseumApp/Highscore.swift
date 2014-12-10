
import Foundation

class Highscore: NSObject, NSCoding {
    var groupId: Int
    var score: Int
    var playerName: String
    var rank: Int
    var hashStr: String?
    
    init(groupId: Int, score: Int, playerName: String, rank: Int, hashStr: String?) {
        self.groupId = groupId
        self.score = score
        self.playerName = playerName
        self.rank = rank
        self.hashStr = hashStr
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(groupId, forKey: "groupId")
        aCoder.encodeInteger(score, forKey: "score")
        aCoder.encodeObject(playerName, forKey: "playerName")
        aCoder.encodeInteger(rank, forKey: "rank")
        aCoder.encodeObject(hashStr, forKey: "hashStr")
    }
    
    required init(coder aDecoder: NSCoder) {
        self.groupId = aDecoder.decodeIntegerForKey("groupId")
        self.score = aDecoder.decodeIntegerForKey("score")
        self.playerName = aDecoder.decodeObjectForKey("playerName") as String
        self.rank = aDecoder.decodeIntegerForKey("rank")
        self.hashStr = aDecoder.decodeObjectForKey("hashStr") as? String
    }
}