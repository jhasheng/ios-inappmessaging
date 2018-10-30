/**
 * Custom event that the host app can call with a custom event name.
 */
@objc public class CustomEvent: Event {
    
    public init(withName name: String) {
        
        super.init(
            eventType: EventType.custom,
            eventName: name,
            customAttributes: nil
        )
    }
    
    override public func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
}
