public class AppStartEvent: Event {
    
    public init(withCustomAttributes customAttributes: [String: String]?) {
        super.init(
            eventType: EventType.appStart,
            customAttributes: customAttributes ?? nil
        )
    }
    
    required public init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}
