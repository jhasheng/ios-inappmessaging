/**
 * Data model for displaying campaign permission.
 */
struct DisplayPermissionResponse: Decodable {
    let display: Bool
    let performPing: Bool
    
    enum CodingKeys: String, CodingKey {
        case display
        case performPing
    }
}
