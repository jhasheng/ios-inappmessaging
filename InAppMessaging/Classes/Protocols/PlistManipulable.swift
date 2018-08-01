/**
 * Protocol to handle plist manipulation.
 */
protocol EventLoggerProtocol {
    static var plistURL: URL { get }
    
    static func savePropertyList(_ plist: Any) throws
    static func loadPropertyList() throws -> [String: [Double]]
    static func deletePropertyList() throws
}

/**
 * Default implementation of EventLoggerProtocol.
 */
extension EventLoggerProtocol {
    /**
     * Save the hashmap of timestamps into the plist file located in the 'Documents' directory.
     * @param { plist: Any } object to save.
     */
    static func savePropertyList(_ plist: Any) throws {
        let plistData = try PropertyListSerialization.data(fromPropertyList: plist, format: .xml, options: 0)
        try plistData.write(to: plistURL)
    }
    
    /**
     * Loads the timestamp plist file located in the 'Documents' directory.
     * @returns { [String: [Double]] } Hashmap of event names to list of timestamps.
     * @throws error when plist file cannot be found.
     */
    static func loadPropertyList() throws -> [String: [Double]] {
        let data = try Data(contentsOf: plistURL)
        guard let plist = try PropertyListSerialization.propertyList(from: data, format: nil) as? [String: [Double]] else {
            return [String: [Double]]()
        }
        
        return plist
    }
    
    /**
     * Deletes the InAppMessaging's timestamp plist file.
     */
    static func deletePropertyList() throws {
        try FileManager.default.removeItem(at: plistURL)
    }
}
