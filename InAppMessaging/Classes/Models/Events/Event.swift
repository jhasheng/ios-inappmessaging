/**
 * Event object that acts as the super class for other pre-defined Event classes.
 * Implements Codable in order for it to be encoded/decoded
 * as a data type and store/load from a property list.
 */
@objc public class Event: NSObject, Encodable {
    var eventType: EventType
    var timestamp: Int
    var eventName: String
    var customAttributes: [String: String]?
    
    init(eventType: EventType, eventName: String, customAttributes: [String: String]?) {
        self.eventType = eventType
        self.timestamp = Date().millisecondsSince1970
        self.eventName = eventName
        self.customAttributes = customAttributes ?? nil
    }
}
