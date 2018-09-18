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
//        self.init(name: eventType.name, eventType: eventType, timestamp: Date().millisecondsSince1970, customAttributes: customAttributes ?? nil)
    }
    
    init(name: String, eventType: EventType, timestamp: Int, customAttributes: [String: String]?) {
        self.name = name
        self.eventType = eventType
        self.timestamp = timestamp
        self.customAttributes = customAttributes ?? nil
    }

    
//    public required convenience init?(coder aDecoder: NSCoder) {
//        let name = aDecoder.decodeObject(forKey: "name") as! String
//        let eventType = aDecoder.decodeInteger(forKey: "eventType")
//        let timestamp = aDecoder.decodeInteger(forKey: "timestamp")
//        let customAttributes = aDecoder.decodeObject(forKey: "customAttributes") as! [String: String]?
//        
//        self.init(
//            name: name,
//            eventType: EventType.init(rawValue: eventType) ?? EventType(rawValue: 0)!,
//            timestamp: timestamp,
//            customAttributes: customAttributes
//        )
//    }
//    
//    public func encode(with aCoder: NSCoder) {
//        aCoder.encode(name, forKey: "name")
//        aCoder.encode(eventType.rawValue, forKey: "eventType")
//        aCoder.encode(timestamp, forKey: "timestamp")
//        aCoder.encode(customAttributes, forKey: "customAttributes")
//    }
}
