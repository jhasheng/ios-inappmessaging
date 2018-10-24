/**
 * Custom event that the host app can call with a custom event name.
 */
@objc public class CustomEvent: Event {
    
    public init(withName name: String, withCustomAttributes customAttributesOptional: [Attribute]?) {
        
        var customAttributes = customAttributesOptional ?? [Attribute]()
        
        
        customAttributes.append(Attribute(withKeyName: Keys.Event.eventName, withValue: name))
        
        super.init(
            eventType: EventType.custom,
            eventName: name,
            customAttributes: customAttributes
        )
    }
    
    override public func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
}
