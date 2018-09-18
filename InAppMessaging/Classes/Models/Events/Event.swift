/**
 * Event object that acts as the super class for other pre-defined Event classes.
 * Implements Codable in order for it to be encoded/decoded
 * as a data type and store/load from a property list.
 */
public class Event: Codable {
    var eventType: EventType
    var name: String
    var timestamp: Int
    var customAttributes: [String: String]?
    
    init(eventType: EventType, customAttributes: [String: String]?) {
        self.eventType = eventType
        self.name = eventType.name
        self.timestamp = Date().millisecondsSince1970
        self.customAttributes = customAttributes ?? nil
    }
    
    init(eventType: EventType, name: String, customAttributes: [String: String]?) {
        self.eventType = eventType
        self.name = name
        self.timestamp = Date().millisecondsSince1970
        self.customAttributes = customAttributes ?? nil
    }
}
