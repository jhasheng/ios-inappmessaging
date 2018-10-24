/**
 * Pre-defined event that is used to signal the success of a purchase action.
 */
@objc public class PurchaseSuccessfulEvent: Event {
    
    public init(withCustomAttributes customAttributes: [Attribute]?) {
        super.init(
            eventType: EventType.purchaseSuccessful,
            eventName: Keys.Event.purchaseSuccessful,
            customAttributes: customAttributes ?? nil
        )
    }
    
    override public func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
}
