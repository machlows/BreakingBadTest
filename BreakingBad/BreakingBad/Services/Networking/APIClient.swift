import Foundation
import Combine

protocol ApiClientInterface {
    func characters() -> AnyPublisher<[Character], Error>
    func quotes(characterName: String) -> AnyPublisher<[Quote], Error>
}

class ApiClient: ApiClientInterface {
    private var urlSession: URLSession
    private let decoder: JSONDecoder
    
    private var cancellables = Set<AnyCancellable>()
    
    init(with session: URLSession = URLSession.shared,
         decoder: JSONDecoder = JSONDecoder()) {
        self.urlSession = session
        self.decoder = decoder
    }
    
    private func requestPublisher<T: Decodable>(request: Request) -> AnyPublisher<T, Error> {
        urlSession
            .dataTaskPublisher(for: request.url)
            .map(\.data)
            .decode(type: T.self, decoder: decoder)
            .catch { _ in Empty<T, Error>() }
            .eraseToAnyPublisher()
    }
    
    func characters() -> AnyPublisher<[Character], Error> {
        requestPublisher(request: .characters)
    }
    
    func quotes(characterName: String) -> AnyPublisher<[Quote], Error> {
        requestPublisher(request: .quotes(characterName))
    }
}
