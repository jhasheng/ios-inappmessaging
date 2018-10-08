/**
 * Pre-defined event that is used to signal the success of a login action.
 */
public class LoginSuccessfulEvent: Event {
    
    public init(withCustomAttributes customAttributes: [String: String]?) {
        super.init(
            eventType: EventType.loginSuccessful,
            customAttributes: customAttributes ?? nil
        )
    }
    
    override public func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
}
