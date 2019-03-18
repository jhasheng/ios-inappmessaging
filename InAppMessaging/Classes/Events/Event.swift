/**
 * Event object that acts as the super class for other pre-defined Event classes.
 * Implements Codable in order for it to be encoded/decoded
 * as a data type and store/load from a property list.
 */
@objc public class Event: NSObject, Codable {
    var eventType: EventType
    var timestamp: Int
    var eventName: String
    
    init(eventType: EventType, eventName: String, timestamp: Int = Date().millisecondsSince1970) {
        self.eventType = eventType
        self.timestamp = timestamp
        self.eventName = eventName
    }
}
