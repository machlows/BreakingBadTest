import Foundation
import Combine
@testable import BreakingBad

class ApiClientMock: ApiClientInterface {
    var charactersToReturn = [Character]()
    func characters() -> AnyPublisher<[Character], Error> {
        Just(charactersToReturn)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    var quotesToReturn = [Quote]()
    func quotes(characterName: String) -> AnyPublisher<[Quote], Error> {
        Just(quotesToReturn)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
