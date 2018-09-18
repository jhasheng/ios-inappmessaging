public class AppStartEvent: Event {
    
    init(customAttributes: [String: String]?) {
        super.init(
            eventType: EventType.appStart,
            customAttributes: customAttributes ?? nil
        )
    }
    
    required convenience public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required public init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}

