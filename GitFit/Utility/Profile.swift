import Foundation

struct Profile : Codable, CustomStringConvertible {    
    var id: Int?
    var firstName: String?
    var lastName: String?
    var trainer: Int?
    var email: String?
    var password: String?
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case id
        case email
        case password = "passcode"
        case trainer = "is_trainer"
    }
    
    var description: String {
        return "\(id ?? -1), \(firstName ?? ""), \(lastName ?? ""), \(trainer ?? 0), \(email ?? ""), \(password ?? "")"
    }
}

struct Creator: Codable {
    var firstName: String?
    var lastName: String?
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}

class Users: NSObject, Codable {
    var id: Int?
    var firstName: String?
    var lastName: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
    }
}

class Stats: NSObject, Codable {
    var number: Int?
    var total: Int?
    var favorites: Int?
    var creations: Int?
}
