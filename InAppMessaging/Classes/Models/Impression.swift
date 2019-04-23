/**
 * Model for an impression object.
 */
struct Impression: Encodable {
    let type: ImpressionType
    let timestamp: Int
}
