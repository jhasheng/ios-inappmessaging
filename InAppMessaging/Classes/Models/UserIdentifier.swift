/**
 * Model for represent an identifier for Rakuten users.
 * The field 'type' corresponds with the Identification enum.
 */
struct UserIdentifier: Codable, Equatable {
    let type: Int
    let id: String
    
    static func == (lhs: UserIdentifier, rhs: UserIdentifier) -> Bool {
        return lhs.type == rhs.type &&
            lhs.id == rhs.id
    }
}
