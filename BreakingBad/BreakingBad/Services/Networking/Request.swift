import Foundation

enum Request {
    static let baseURL = URL(string: "https://www.breakingbadapi.com/api/")!
    
    case characters
    case quotes(String)
    
    var url: URL {
        switch self {
        case .characters:
            return Request.baseURL.appendingPathComponent("characters")
        case .quotes(let characterName):
            let url = Request.baseURL.appendingPathComponent("quote")
            var urlComps = URLComponents(string: url.absoluteString)!
            
            urlComps.queryItems = [URLQueryItem(name: "author", value: characterName)]
            return urlComps.url!
            
        }
    }
}
