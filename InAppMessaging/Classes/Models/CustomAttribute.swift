/**
 * Model to represent a custom attribute that is returned by the ping request in triggers.
 */
public struct Attribute: Codable {
    let name: String
    let value: String
    
    public init(withKeyName name: String, withValue value: String) {
        self.name = name
        self.value = value
    }
}
