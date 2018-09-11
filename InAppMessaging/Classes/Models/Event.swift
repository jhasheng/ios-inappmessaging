/**
 * Event object that provides properties for a specific event.
 * Implements NSObject and NSCoding in order for it to be encoded/decoded
 * as a data type and store/load from a property list.
 */
class Event: NSObject, NSCoding, Codable {
    var name: String
    var timestamp: Int
    
    init(name: String, timestamp: Int) {
        self.name = name
        self.timestamp = timestamp
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let timestamp = aDecoder.decodeInteger(forKey: "timestamp")
        
        self.init(name: name, timestamp: timestamp)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(timestamp, forKey: "timestamp")
    }
}
