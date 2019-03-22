/**
 * Model to represent a trigger sent back by the IAM Ping service.
 */
struct TriggerAttribute: Codable {
    let key: String
    let value: String
    let type: Int
    let `operator`: Int
}
