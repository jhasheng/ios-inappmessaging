/**
 * Event object that acts as the super class for other pre-defined Event classes.
 * Implements Codable in order for it to be encoded/decoded
 * as a data type and store/load from a property list.
 */
@objc public class Event: NSObject, Codable {
    var eventType: EventType
    var timestamp: Int
    var eventName: String
    
    var dictionary: [String: Any] {
        switch self.eventType {
            case .invalid:
                break
            case .appStart:
                if let appStartEvent = self as? AppStartEvent {
                    return appStartEvent.dict
                }
            case .loginSuccessful:
                if let loginSuccessfulEvent = self as? LoginSuccessfulEvent {
                    return loginSuccessfulEvent.dict
                }
            case .purchaseSuccessful:
                if let purchaseSuccessfulEvent = self as? PurchaseSuccessfulEvent {
                    return purchaseSuccessfulEvent.dict
                }
            case .custom:
                if let customEvent = self as? CustomEvent {
                    return customEvent.dict
                }
        }
        return [:]
    }
    
    init(eventType: EventType, eventName: String, timestamp: Int = Date().millisecondsSince1970) {
        self.eventType = eventType
        self.timestamp = timestamp
        self.eventName = eventName
    }
    
    /**
     * Let subclass override to retrieve attribute map.
     */
    func getAttributeMap() -> [String: CustomAttribute]? {
        return nil
    }
}
