/**
 * Data model for displaying campaign permission.
 */
struct DisplayPermissionResponse: Decodable {
    let action: Int
    let actionName: String
    
    enum CodingKeys: String, CodingKey {
        case action
        case actionName
    }
}
