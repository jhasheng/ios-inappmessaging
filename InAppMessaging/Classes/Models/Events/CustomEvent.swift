/**
 * Custom event that the host app can call with a custom event name.
 */
@objc public class CustomEvent: Event {
    
    public init(withName name: String, withCustomAttributes customAttributesOptional: [String: String]?) {
        
        var customAttributes = customAttributesOptional ?? [String: String]()
        customAttributes["name"] = name
        
        super.init(
            eventType: EventType.custom,
            customAttributes: customAttributes
        )
    }
    
    override public func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
}
