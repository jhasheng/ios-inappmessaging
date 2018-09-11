/**
 * Protocol that is conformed to when a class has to manipulate property list files.
 */
protocol PlistManipulable {
    static var plistURL: URL { get }
    
    /**
     * Save any object into the plist file located in plistURL directory.
     * @param { plist: Any } object to save.
     * @throws when plist fails to serialize
     */
    static func savePropertyList(_ plist: Any) throws
    
    /**
     * Loads the plist file located in the plistURL directory.
     * @returns { [String: [T]] } dictionary with the plist file's content.
     * @throws error when plist file cannot be found.
     */
    static func loadPropertyList<T>() throws -> [T]?
    
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
    
    static func savePropertyList(_ plist: Any) throws {
        let plistData = try PropertyListSerialization.data(fromPropertyList: plist, format: .xml, options: 0)
        try plistData.write(to: plistURL)
    }
    
    static func loadPropertyList<T>() throws -> [T]? {
        let data = try Data(contentsOf: plistURL)
        guard let plist = try PropertyListSerialization.propertyList(from: data, format: nil) as? [T] else {
            return [T]()
        }
        
        return plist
    }
    
    static func deletePropertyList() throws {
        try FileManager.default.removeItem(at: plistURL)
    }
}
