/**
 * Pre-defined event that is used to signal the startup of the host application.
 */
public class AppStartEvent: Event {

    public init(withCustomAttributes customAttributes: [String: String]?) {
        super.init(
            eventType: EventType.appStart,
            customAttributes: customAttributes ?? nil
        )
    }
    
    private enum CodingKeys: String, CodingKey {
        case eventType
        case name
        case timestamp
        case customAttributes
    }
    
    //TODO(Daniel Tam) Fix decodable issue.
    required public init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    /**
     * Override encode() to due to an Codable issue when inheriting.
     * More information here: https://bugs.swift.org/browse/SR-5125 and
     * https://stackoverflow.com/questions/44553934/using-decodable-in-swift-4-with-inheritance
     */
    override public func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
}
