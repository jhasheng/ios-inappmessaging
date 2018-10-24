public struct Attribute: Codable {
    let name: String
    let value: String
    
    public init(withKeyName name: String, withValue value: String) {
        self.name = name
        self.value = value
    }
}
