/**
 * Event object that provides properties for a specific event.
 * Implements NSObject and NSCoding in order for it to be encoded/decoded
 * as a data type and store/load from a property list.
 */
public class Event: Codable {
    var eventType: EventType
    var name: String
    var timestamp: Int
    var customAttributes: [String: String]?
    
    init(eventType: EventType, customAttributes: [String: String]?) {
        self.name = eventType.name
        self.eventType = eventType
        self.timestamp = Date().millisecondsSince1970
        self.customAttributes = customAttributes ?? nil
    }
}
