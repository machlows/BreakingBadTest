import Foundation
import Combine
import SwiftUI

protocol Navigable: AnyObject, Identifiable, Hashable {}

extension Navigable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

enum Screen: Hashable {
    case detailsScreen(viewModel: DetailsViewModel)
}

class FlowViewModel: ObservableObject {
    private var subscription = Set<AnyCancellable>()
    private var apiClient: ApiClientInterface = ApiClient()
    private var likedCharacterService: LikedCharactersServiceInterface = LikedCharactersService()
    
    @Published var navigationPath: [Screen] = []

    func makeCharactersViewModel() -> CharactersViewModel {
        let viewModel = CharactersViewModel(apiClient: apiClient,
                                            likedCharactersService: likedCharacterService)
        
        viewModel.didSelectCharacter
            .sink(receiveValue: didSelectCharacter)
            .store(in: &subscription)
        
        return viewModel
    }
    
    func makeDetailsViewModel(for character: Character) -> DetailsViewModel {
        let viewModel = DetailsViewModel(character: character,
                                         apiClient: apiClient,
                                         likedCharactersService: likedCharacterService)
        return viewModel
    }
    
    func didSelectCharacter(character: Character) {
        navigationPath.append(.detailsScreen(viewModel: makeDetailsViewModel(for: character)))
    }
}
