/**
 * Pre-defined event that is used to signal the success of a login action.
 */
@objc public class LoginSuccessfulEvent: Event {
    
    var dict: [String: Any] {
        return [
            "eventType": super.eventType.rawValue,
            "eventName": super.eventName,
            "timestamp": super.timestamp
        ]
    }
    
    @objc
    public init() {
        super.init(
            eventType: EventType.loginSuccessful,
            eventName: Keys.Event.loginSuccessful
        )
    }
    
    init(timestamp: Int) {
        super.init(
            eventType: EventType.loginSuccessful,
            eventName: Keys.Event.loginSuccessful,
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
