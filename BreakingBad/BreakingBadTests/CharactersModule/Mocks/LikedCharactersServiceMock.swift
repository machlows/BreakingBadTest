import Foundation
@testable import BreakingBad

class LikedCharactersServiceMock: LikedCharactersServiceInterface {
    var isCharacterLikedToReturn: Bool = false
    func isCharacterLiked(_ characterId: Int) -> Bool {
        isCharacterLikedToReturn
    }
    
    var likedCharactersId = [Int]()
    func likeCharacter(_ characterId: Int) {
        likedCharactersId.append(characterId)
    }
    
    func unlikeCharacter(_ characterId: Int) {
        likedCharactersId.removeAll(where: {$0 == characterId})
    }
}
