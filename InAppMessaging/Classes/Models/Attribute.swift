/**
 * Model to represent a basic key value pair.
 */
struct Attribute: Codable {
    let k: String
    let v: String
    
    init(withKeyName k: String, withValue v: String) {
        self.k = k
        self.v = v
    }
}
