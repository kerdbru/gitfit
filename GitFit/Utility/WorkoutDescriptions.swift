import Foundation

struct WorkoutDescription : Codable {
    var id: Int?
    var name: String?
    var ratingSum: Int?
    var ratingCount: Int?
    var type: String?
    var firstName: String?
    var accountId: Int?
    var favorite: Int?
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case ratingSum = "rating_sum"
        case name
        case id
        case type
        case accountId = "account_id"
        case ratingCount = "rating_count"
        case favorite
    }
}

class Favorite : NSObject, Codable {
    var id: Int?
    var name: String?
    var type: String?
    var accountId: Int?
    
    enum CodingKeys: String, CodingKey {
        case accountId = "account_id"
        case name
        case id
        case type
    }
}
