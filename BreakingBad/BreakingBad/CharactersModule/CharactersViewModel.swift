import Foundation
import Combine
import SwiftUI

struct CharacterViewItemModel: Equatable{
    let character: Character
    let isLiked: Bool
}

class CharactersViewModel: ObservableObject, Navigable {
    @Published var items = [CharacterViewItemModel]()
    
    private var apiClient: ApiClientInterface
    private var likedCharactersService: LikedCharactersServiceInterface
    
    let didSelectCharacter = PassthroughSubject<Character, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(apiClient: ApiClientInterface, likedCharactersService: LikedCharactersServiceInterface) {
        self.apiClient = apiClient
        self.likedCharactersService = likedCharactersService
    }
    
    func loadData() {
        apiClient.characters()
            .receive(on: DispatchQueue.main)
            .map { [weak self] characters in
                let itemModels = characters.map { character in
                    let isLiked = self?.likedCharactersService.isCharacterLiked(character.id) ?? false
                    return CharacterViewItemModel(character: character,
                                                  isLiked: isLiked)
                }
                return itemModels
            }
            .replaceError(with: [CharacterViewItemModel]())
            .sink(receiveValue: {[weak self] models in
                guard let self = self else { return }
                self.items = models
            })
            .store(in: &cancellables)
    }
    
    func didSelect(index: Int) {
        guard items.count > index else {
            return
        }
        didSelectCharacter.send(items[index].character)
    }
    
    func didLikeCharacter(_ characterId: Int) {
        likedCharactersService.likeCharacter(characterId)
       
        if let row = items.firstIndex(where: { $0.character.id == characterId}) {
            items[row] = CharacterViewItemModel(character: items[row].character, isLiked: true)
        }
    }
    
    func didUnlikeCharacter(_ characterId: Int) {
        likedCharactersService.unlikeCharacter(characterId)
        
        if let row = items.firstIndex(where: { $0.character.id == characterId}) {
            items[row] = CharacterViewItemModel(character: items[row].character, isLiked: false)
        }
    }
}
