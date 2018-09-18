/**
 * Protocol that is conformed to when a class has to manipulate property list files.
 */
protocol PlistManipulable {
    static var plistURL: URL { get }
    
    /**
     * Save any object into the plist file located in plistURL directory.
     * @param { plist: T } object to save.
     * @throws when plist fails to serialize
     */
    static func savePropertyList<T: Encodable>(_ plist: T) throws
    
    /**
     * Loads the plist file located in the plistURL directory.
     * @returns { [String: [T]] } dictionary with the plist file's content.
     * @throws error when plist file cannot be found.
     */
    static func loadPropertyList<T: Decodable>() throws -> [T]?
    
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
//        let plistData: Data = NSKeyedArchiver.archivedData(withRootObject: plist)
        do {
            let plistData: Data = try JSONEncoder().encode(plist)
            try plistData.write(to: plistURL)

        } catch {
            print(error)
        }
    }
    
    static func loadPropertyList<T: Decodable>() throws -> [T]? {
        let plistData = try Data(contentsOf: plistURL)
//        guard let plist = NSKeyedUnarchiver.unarchiveObject(with: plistData) as? [T] else {
//            return nil
//        }
        guard let plist = try? JSONDecoder().decode(T.self, from: plistData) else {
            return nil
        }
        
        return [plist]
    }
    
    static func deletePropertyList() throws {
        try FileManager.default.removeItem(at: plistURL)
    }
}
