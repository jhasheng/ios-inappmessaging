/**
 * Model to represent a custom attribute that is returned by the ping request in triggers.
 */
public struct Attribute: Codable {
    let key: String
    let value: String
    
    public init(withKeyName key: String, withValue value: String) {
        self.key = key
        self.value = value
    }
}
