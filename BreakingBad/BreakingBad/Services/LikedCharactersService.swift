import Foundation
import SwiftUI

protocol LikedCharactersServiceInterface {
    func isCharacterLiked(_ characterId: Int) -> Bool
    func likeCharacter(_ characterId: Int)
    func unlikeCharacter(_ characterId: Int)
}

class LikedCharactersService: LikedCharactersServiceInterface {
    @AppStorage("likedCharactersData") var likedCharactersData: Data = Data()
    private var likedCharacters =  [Int]()
    
    init() {
        likedCharacters = Storage.loadArray(data: likedCharactersData)
    }
    
    func isCharacterLiked(_ characterId: Int) -> Bool {
        likedCharacters.contains(characterId)
    }
    
    func likeCharacter(_ characterId: Int) {
        likedCharacters.append(characterId)
        likedCharactersData = Storage.archiveArray(object: likedCharacters)
    }
    
    func unlikeCharacter(_ characterId: Int) {
        likedCharacters.removeAll(where: {$0 == characterId})
        likedCharactersData = Storage.archiveArray(object: likedCharacters)
    }
}
