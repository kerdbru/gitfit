import Foundation

struct ExerciseOrder: Codable {
    var id: Int?
    var position: Int?
    var amount: Int?
    var weight: Int?
    var sets: Int?
    var label: String?
    var name: String?
    var description: String?
    var exerciseId: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case position
        case amount
        case weight
        case sets
        case label
        case name
        case description
        case exerciseId = "exercise_id"
    }
}
