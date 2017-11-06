import Foundation

struct WorkoutDescription : Codable {
    var id: Int?
    var name: String?
    var ratingSum: Int?
    var ratingCount: Int?
    var type: String?
    var firstName: String?
    var accountId: Int?
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case ratingSum = "rating_sum"
        case name
        case id
        case type
        case accountId = "account_id"
        case ratingCount = "rating_count"
    }
}

struct Favorite : Codable {
    var id: Int?
    var name: String?
    var type: String?
}
