/**
 * Pre-defined event that is used to signal the startup of the host application.
 */
@objc public class AppStartEvent: Event {
    
    var isUserLoggedIn: Bool
    var getDictionary: [String: Any] {
        return [
            "eventType": super.eventType,
            "eventName": super.eventName,
            "timestamp": super.timestamp,
            "isUserLoggedIn": self.isUserLoggedIn
        ]
    }

    public init(isUserLoggedIn: Bool) {
        self.isUserLoggedIn = isUserLoggedIn

        super.init(
            eventType: EventType.appStart,
            eventName: Keys.Event.appStart
        )
    }
    
    init(isUserLoggedIn: Bool, timestamp: Int) {
        self.isUserLoggedIn = isUserLoggedIn
        
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
