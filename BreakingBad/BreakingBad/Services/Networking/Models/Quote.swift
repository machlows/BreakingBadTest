import Foundation

struct Quote: Codable, Equatable, Identifiable {
    var id: Int
    var quote: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "quote_id"
        case quote
    }
}
