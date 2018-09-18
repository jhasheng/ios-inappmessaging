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
    
    /**
     * Override encode() due to an Codable issue when inheriting.
     * More information here: https://bugs.swift.org/browse/SR-5125
     */
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
}
