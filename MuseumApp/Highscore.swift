
import Foundation

class Highscore: NSObject {
    var groupId: Int
    var score: Int
    var playerName: String
    var rank: Int
    var hashStr: String
    
    init(groupId: Int, score: Int, playerName: String, rank: Int, hashStr: String) {
        self.groupId = groupId
        self.score = score
        self.playerName = playerName
        self.rank = rank
        self.hashStr = hashStr
    }
}