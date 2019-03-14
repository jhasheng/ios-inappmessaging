/**
 * Model to represent a custom attribute that is returned by the ping request in triggers.
 */
@objc public class CustomAttribute: NSObject {
    let name: String
    let value: Any
    let type: Int
    
    public init(withKeyName name: String, withValue value: String) {
        self.name = name
        self.value = value
        self.type = AttributeType.string.rawValue
    }
    
    public init(withKeyName name: String, withValue value: Int) {
        self.name = name
        self.value = value
        self.type = AttributeType.integer.rawValue
    }
    
    public init(withKeyName name: String, withValue value: Double) {
        self.name = name
        self.value = value
        self.type = AttributeType.double.rawValue
    }
    
    public init(withKeyName name: String, withValue value: Bool) {
        self.name = name
        self.value = value
        self.type = AttributeType.timeInMilli.rawValue
    }
}
	
