/**
 * Model for represent an identifier for Rakuten users.
 * The field 'type' corresponds with the Identification enum.
 */
struct UserIdentifier: Codable {
    let type: Int
    let id: String
}
