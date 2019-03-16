/**
 * Pre-defined event that is used to signal the startup of the host application.
 */
@objc public class AppStartEvent: Event {
    
    // For broadcasting to RAT SDK. 'eventType' field will be removed.
    var dict: [String: Any] {
        return [
            "eventName": super.eventName,
            "timestamp": super.timestamp
        ]
    }

    @objc
    public init(isUserLoggedIn: Bool) {

        super.init(
            eventType: EventType.appStart,
            eventName: Keys.Event.appStart
        )
    }
    
    init(isUserLoggedIn: Bool, timestamp: Int) {
        
        super.init(
            eventType: EventType.appStart,
            eventName: Keys.Event.appStart,
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
