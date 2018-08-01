protocol EventLoggerProtocol {
    static var eventLog: [String: [Double]] { get set }
    static var plistURL: URL { get }
    
    static func savePropertyList(_ plist: Any) throws
    static func loadPropertyList() throws -> [String: [Double]]
    static func deletePropertyList() throws
}

/**
 * Struct to handle logging events by the host application.
 */
struct EventLogger: EventLoggerProtocol {
    static var eventLog = [String: [Double]]()
    static var plistURL: URL {
        let documentDirectoryURL =  try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        return documentDirectoryURL.appendingPathComponent(Keys.File.TimestampPlist)
    }
}

/**
 * Default implementation of EventLoggerProtocol.
 */
extension EventLoggerProtocol {
    /**
     * Log the event sent by the host application in a hashmap of event name to list of timestamps.
     * Saves into a plist file.
     * TODO(daniel.tam) Clear file when it is dumped to a server.
     * @param { activityName: String } name of the event sent by the host application.
     */
    static internal func logEvent(_ eventName: String) {
        
        if self.eventLog.isEmpty {
            do {
                self.eventLog = try self.loadPropertyList()
            } catch {
                #if DEBUG
                print(error)
                #endif
            }
        }
        
        if self.eventLog[eventName] != nil {
            var tempLog = self.eventLog[eventName]
            tempLog?.append(Date().timeIntervalSince1970)
            self.eventLog[eventName] = tempLog
        } else {
            self.eventLog[eventName] = [Date().timeIntervalSince1970]
        }
        
        do {
            try self.savePropertyList(self.eventLog)
        } catch {
            #if DEBUG
            print(error)
            #endif
        }
    }
    
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
