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
                eventName: Keys.Event.purchaseSuccessful,
                customAttributes: nil
            )
    }
    
    override public func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
}
