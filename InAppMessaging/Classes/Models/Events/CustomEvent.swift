/**
 * Custom event that the host app can call with a custom event name.
 */
public class CustomEvent: Event {
    
    public init(withName name: String, withCustomAttributes customAttributesOptional: [String: String]?) {
        
        var customAttributes = customAttributesOptional ?? [String: String]()
        customAttributes["name"] = name
        
        super.init(
            eventType: EventType.custom,
            customAttributes: customAttributes
        )
    }
    
    private enum CodingKeys: String, CodingKey {
        case eventType
        case name
        case timestamp
        case customAttributes
    }
    
    /**
     * Override encode() to due to an Codable issue when inheriting.
     * More information here: https://bugs.swift.org/browse/SR-5125 and
     * https://stackoverflow.com/questions/44553934/using-decodable-in-swift-4-with-inheritance
     */
    override public func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
}
