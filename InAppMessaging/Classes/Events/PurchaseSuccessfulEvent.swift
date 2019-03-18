/**
 * Pre-defined event that is used to signal the success of a purchase action.
 */
@objc public class PurchaseSuccessfulEvent: Event {
    
    static let PURCHASE_AMOUNT_MICROS = "purchaseAmountMicros"
    static let NUMBER_OF_ITEMS = "numberOfItems"
    static let CURRENCY_CODE = "currencyCode"
    static let ITEM_ID_LIST = "itemIdList"
    
    var purchaseAmount: Int
    var numberOfItems: Int
    var currencyCode: String
    var itemList: [String]
    
    // For broadcasting to RAT SDK. 'eventType' field will be removed.
    var dict: [String: Any] {
        return [
            "eventName": super.eventName,
            "timestamp": super.timestamp,
            "purchaseAmountMicros": self.purchaseAmount,
            "numberOfItems": self.numberOfItems,
            "currencyCode": self.currencyCode,
            "itemIdList": self.itemList
        ]
    }
    
    @objc
    public init(
        withPurchaseAmount purchaseAmount: Int,
        withNumberOfItems numberOfItems: Int,
        withCurrencyCode currencyCode: String,
        withItems itemList: [String]) {
        
            self.purchaseAmount = purchaseAmount
            self.numberOfItems = numberOfItems
            self.currencyCode = currencyCode
            self.itemList = itemList
        
            super.init(
                eventType: EventType.purchaseSuccessful,
                eventName: Keys.Event.purchaseSuccessful
            )
    }
    
    init(
        withPurchaseAmount purchaseAmount: Int,
        withNumberOfItems numberOfItems: Int,
        withCurrencyCode currencyCode: String,
        withItems itemList: [String],
        timestamp: Int) {
        
            self.purchaseAmount = purchaseAmount
            self.numberOfItems = numberOfItems
            self.currencyCode = currencyCode
            self.itemList = itemList
        
            super.init(
                eventType: EventType.purchaseSuccessful,
                eventName: Keys.Event.purchaseSuccessful,
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
