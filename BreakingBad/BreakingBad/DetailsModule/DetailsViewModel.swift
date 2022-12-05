import Foundation
import Combine
import SwiftUI

struct CharacterDetailsViewModel {
    let character: Character
    var isLiked: Bool
}

class DetailsViewModel: ObservableObject, Navigable {
    @Published var quotes = [Quote]()
    @Published var characterDetails: CharacterDetailsViewModel
    
    private var apiClient: ApiClientInterface
    private var likedCharactersService: LikedCharactersServiceInterface
    
    private var cancellables = Set<AnyCancellable>()
    
    init(character: Character,
         apiClient: ApiClientInterface,
         likedCharactersService: LikedCharactersServiceInterface ) {
        self.apiClient = apiClient
        self.likedCharactersService = likedCharactersService
        self.characterDetails = CharacterDetailsViewModel(character: character,
                                                          isLiked:likedCharactersService.isCharacterLiked(character.id))
    }
    
    func loadData() {
        apiClient.quotes(characterName: characterDetails.character.name.replacingOccurrences(of: " ",
                                                                                             with: "+"))
        .receive(on: DispatchQueue.main)
        .replaceError(with: [Quote]())
        .sink(receiveValue: {[weak self] quotes in
            guard let self = self else { return }
            self.quotes = quotes
        })
        .store(in: &cancellables)
    }
    
    func didLikeCharacter(_ characterId: Int) {
        likedCharactersService.likeCharacter(characterId)
        characterDetails.isLiked = true
    }
    
    func didUnlikeCharacter(_ characterId: Int) {
        likedCharactersService.unlikeCharacter(characterId)
        characterDetails.isLiked = false
    }
}
