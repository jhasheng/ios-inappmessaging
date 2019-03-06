/**
 * Protocol that is conformed to when a class has to manipulate property list files.
 */
protocol PlistManipulable {
    static var plistURL: URL { get }
    
    /**
     * Save any object into the plist file located in plistURL directory.
     * @param { plist: T } object to encode and save to the plist. T is guarantee to conform to Encodable.
     * @throws when plist fails to serialize
     */
    static func savePropertyList<T: Encodable>(_ plist: T) throws
    
    /**
     * Loads the plist file located in the plistURL directory.
     * @returns { [[String: Any]]? } array of raw data from plist.
     * @throws error when plist file cannot be found.
     */
    static func loadPropertyList() throws -> [[String: Any]]?
    
    /**
     * Deletes the InAppMessaging's timestamp plist file.
     * @throws when the plist file manager fails to remove the plist.
     */
    static func deletePropertyList() throws
}

/**
 * Default implementation of PlistManipulable.
 */
extension PlistManipulable {
    
    static func savePropertyList<T: Encodable>(_ plist: T) throws {
        let plistData: Data = try PropertyListEncoder().encode(plist)
        try plistData.write(to: plistURL, options: .completeFileProtection)
    }
    
    static func loadPropertyList() throws -> [[String: Any]]? {
        let plistData = try Data(contentsOf: plistURL)
        return try PropertyListSerialization.propertyList(from: plistData, options: [], format:nil) as? [[String: Any]]
    }
    
    static func deletePropertyList() throws {
        try FileManager.default.removeItem(at: plistURL)
    }
}
