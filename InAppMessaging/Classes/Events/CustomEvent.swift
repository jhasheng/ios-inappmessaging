/**
 * Custom event that the host app can call with a custom event name.
 */
@objc public class CustomEvent: Event {
    
    var customAttributes: [CustomAttribute]?
    var dictionary: [String: Any] {
        return [
            "eventType": super.eventType,
            "eventName": super.eventName,
            "timestamp": super.timestamp,
            "customAttributes": self.customAttributes
        ]
    }
    
    public init(withName name: String, withCustomAttributes customAttributes: [CustomAttribute]?) {
        
        self.customAttributes = customAttributes
        
        super.init(
            eventType: EventType.custom,
            eventName: name
        )
    }
    
    init(withName name: String, withCustomAttributes customAttributes: [CustomAttribute]?, timestamp: Int) {
        
        self.customAttributes = customAttributes
        
        super.init(
            eventType: EventType.custom,
            eventName: name,
            timestamp: timestamp
        )
    }
    
    required public init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    override public func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
}   
