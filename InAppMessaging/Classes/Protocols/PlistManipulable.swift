/**
 * Protocol to handle plist manipulation.
 */
protocol PlistManipulable {
    static var plistURL: URL { get }
    
    static func savePropertyList(_ plist: Any) throws
    static func loadPropertyList() throws -> [String: [Any]]
    static func deletePropertyList() throws
}

/**
 * Default implementation of PlistManipulable.
 */
extension PlistManipulable {
    /**
     * Save any object into the plist file located in plistURL directory.
     * @param { plist: Any } object to save.
     */
    static func savePropertyList(_ plist: Any) throws {
        let plistData = try PropertyListSerialization.data(fromPropertyList: plist, format: .xml, options: 0)
        try plistData.write(to: plistURL)
    }
    
    /**
     * Loads the plist file located in the plistURL directory.
     * @returns { [String: [Any]] } dictionary with the plist file's content.
     * @throws error when plist file cannot be found.
     */
    static func loadPropertyList() throws -> [String: [Any]] {
        let data = try Data(contentsOf: plistURL)
        guard let plist = try PropertyListSerialization.propertyList(from: data, format: nil) as? [String: [Any]] else {
            return [String: [Any]]()
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
