/**
 * Model to represent a custom attribute that is returned by the ping request in triggers.
 */
@objc
public class CustomAttribute: NSObject {
    let name: String
    let value: Any
    let type: Int
    
    var convertToDict: [String: Any] {
        return [
            "name": name,
            "value": value,
            "type": type
        ]
    }
    
    @objc
    public init(withKeyName name: String, withStringValue value: String) {
        self.name = name
        self.value = value
        self.type = AttributeType.string.rawValue
    }
    
    @objc
    public init(withKeyName name: String, withIntValue value: Int) {
        self.name = name
        self.value = value
        self.type = AttributeType.integer.rawValue
    }
    
    @objc
    public init(withKeyName name: String, withDoubleValue value: Double) {
        self.name = name
        self.value = value
        self.type = AttributeType.double.rawValue
    }
    
    @objc
    public init(withKeyName name: String, withBoolValue value: Bool) {
        self.name = name
        self.value = value
        self.type = AttributeType.boolean.rawValue
    }
    
    @objc
    public init(withKeyName name: String, withTimeInMilliValue value: Int) {
        self.name = name
        self.value = value
        self.type = AttributeType.timeInMilli.rawValue
    }
}
	
