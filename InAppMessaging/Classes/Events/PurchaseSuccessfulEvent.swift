/**
 * Pre-defined event that is used to signal the success of a purchase action.
 */
@objc public class PurchaseSuccessfulEvent: Event {
    
    final let PURCHASE_AMOUNT_MICROS = "purchaseAmountMicros"
    final let NUMBER_OF_ITEMS = "numberOfItems"
    final let CURRENCY_CODE = "currencyCode"
    final let ITEM_ID_LIST = "itemIdList"
    
    var purchaseAmount = -1
    var numberOfItems = -1
    var currencyCode = "UNKNOWN"
    var itemList = [String]()
    
    // For broadcasting to RAT SDK. 'eventType' field will be removed.
    var dict: [String: Any] {
        return [
            "eventName": super.eventName,
            "timestamp": super.timestamp,
            PURCHASE_AMOUNT_MICROS: self.purchaseAmount,
            NUMBER_OF_ITEMS: self.numberOfItems,
            CURRENCY_CODE: self.currencyCode,
            ITEM_ID_LIST: self.itemList
        ]
    }
    
    var customAttributes: [CustomAttribute] {
        return [
            CustomAttribute(withKeyName: PURCHASE_AMOUNT_MICROS, withIntValue: self.purchaseAmount),
            CustomAttribute(withKeyName: NUMBER_OF_ITEMS, withIntValue: self.numberOfItems),
            CustomAttribute(withKeyName: CURRENCY_CODE, withStringValue: self.currencyCode),
            CustomAttribute(withKeyName: ITEM_ID_LIST, withStringValue: self.itemList.joined(separator: "|"))
        ]
    }
    
    @objc
    public init() {
        super.init(
            eventType: EventType.purchaseSuccessful,
            eventName: Constants.Event.purchaseSuccessful
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
                eventName: Constants.Event.purchaseSuccessful,
                timestamp: timestamp
            )
    }
    
    required public init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    override public func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
    
    @objc
    public func setPurchaseAmount(_ purchaseAmount: Int) -> PurchaseSuccessfulEvent {
        self.purchaseAmount = purchaseAmount
        return self
    }
    
    @objc
    public func setNumberOfItems(_ numberOfItems: Int) -> PurchaseSuccessfulEvent {
        self.numberOfItems = numberOfItems
        return self
    }
    
    @objc
    public func setCurrencyCode(_ currencyCode: String) -> PurchaseSuccessfulEvent {
        self.currencyCode = currencyCode
        return self
    }
    
    @objc
    public func setItemList(_ itemList: [String]) -> PurchaseSuccessfulEvent {
        self.itemList = itemList
        return self
    }
    
    /**
     * Create a mapping used to return a mapping of the customAttribute list.
     */
    override func getAttributeMap() -> [String: CustomAttribute] {
        return [
            PURCHASE_AMOUNT_MICROS: CustomAttribute(withKeyName: PURCHASE_AMOUNT_MICROS, withIntValue: self.purchaseAmount),
            NUMBER_OF_ITEMS: CustomAttribute(withKeyName: NUMBER_OF_ITEMS, withIntValue: self.numberOfItems),
            CURRENCY_CODE: CustomAttribute(withKeyName: CURRENCY_CODE, withStringValue: self.currencyCode),
            ITEM_ID_LIST: CustomAttribute(withKeyName: ITEM_ID_LIST, withStringValue: self.itemList.joined(separator: "|"))
        ]
    }
}
