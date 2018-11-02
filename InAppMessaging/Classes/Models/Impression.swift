/**
 * Model for an impression object.
 */
struct Impression: Encodable {
    let type: ImpressionType
    let ts: Int
}
