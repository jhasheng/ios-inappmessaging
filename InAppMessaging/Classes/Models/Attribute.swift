/**
 * Model to represent a custom attribute that is returned by the ping request in triggers.
 */
@objc public class Attribute: NSObject, Codable {
    let k: String
    let v: String
    
    public init(withKeyName k: String, withValue v: String) {
        self.k = k
        self.v = v
    }
}
