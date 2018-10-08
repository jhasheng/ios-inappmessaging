/**
 * Pre-defined event that is used to signal the startup of the host application.
 */
public class AppStartEvent: Event {

    public init(withCustomAttributes customAttributes: [String: String]?) {
        super.init(
            eventType: EventType.appStart,
            customAttributes: customAttributes ?? nil
        )
    }
    
    override public func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
}
