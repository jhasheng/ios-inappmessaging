/**
 * Pre-defined event that is used to signal the startup of the host application.
 */
@objc public class AppStartEvent: Event {
    
    var isUserLoggedIn: Bool

    public init(isUserLoggedIn: Bool) {
        self.isUserLoggedIn = isUserLoggedIn

        super.init(
            eventType: EventType.appStart,
            eventName: Keys.Event.appStart,
            customAttributes: nil
        )
    }
    
    override public func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
}
