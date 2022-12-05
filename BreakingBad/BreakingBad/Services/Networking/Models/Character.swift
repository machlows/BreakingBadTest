import Foundation

struct Character: Codable, Equatable {
    var id: Int
    var name: String
    var image: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "char_id"
        case name
        case image = "img"
    }
}
