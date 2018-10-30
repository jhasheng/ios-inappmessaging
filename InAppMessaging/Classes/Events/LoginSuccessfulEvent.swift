/**
 * Pre-defined event that is used to signal the success of a login action.
 */
@objc public class LoginSuccessfulEvent: Event {
    
    public init(withCustomAttributes customAttributes: [Attribute]?) {
        super.init(
            eventType: EventType.loginSuccessful,
            eventName: Keys.Event.loginSuccessful,
            customAttributes: customAttributes ?? nil
        )
    }
    
    override public func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
}