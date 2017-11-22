
import Foundation

class Exercise: NSObject, Codable {
    var id: Int?
    var name: String?
    var exerciseDescription: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case exerciseDescription = "description"
    }
}
