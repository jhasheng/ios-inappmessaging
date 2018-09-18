/**
 * Event object that provides properties for a specific event.
 * Implements NSObject and NSCoding in order for it to be encoded/decoded
 * as a data type and store/load from a property list.
 */
public class Event: NSObject, NSCoding, Codable {
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
    
    required convenience public init?(coder aDecoder: NSCoder) {
        let eventType = aDecoder.decodeObject(forKey: "eventType") as! EventType
        let customAttributes = aDecoder.decodeObject(forKey: "customAttributes") as! [String: String]?
        
        self.init(eventType: eventType, customAttributes: customAttributes)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(eventType, forKey: "eventType")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(timestamp, forKey: "timestamp")
        aCoder.encode(customAttributes, forKey: "customAttributes")
    }
}
