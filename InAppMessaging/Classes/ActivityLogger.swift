/**
 * Class to handle logging events by the host application.
 */
class ActivityLogger {
    
    static var activityLog = [String: [Double]]()
    static var plistURL : URL {
        let documentDirectoryURL =  try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        return documentDirectoryURL.appendingPathComponent(Keys.File.TimestampPlist)
    }

    /**
     * Log the activity sent by the host application in a hashmap of event name to list of timestamps.
     * Saves into a plist file.
     * TODO(daniel.tam) Clear file when it is dumped to a server.
     * @param { activityName: String} name of the event sent by the host application.
     */
    static internal func logActivity(_ activityName: String) {
        
        if self.activityLog.isEmpty {
            do {
                self.activityLog = try self.loadPropertyList()
            } catch {
                #if DEBUG
                    print(error)
                #endif
            }
        }
        
        if self.activityLog[activityName] != nil {
            var tempLog = self.activityLog[activityName]
            tempLog?.append(CommonUtility().getTimeStamp())
            self.activityLog[activityName] = tempLog
        } else {
            self.activityLog[activityName] = [CommonUtility().getTimeStamp()]
        }
        
       self.savePropertyList(self.activityLog)
    }
    
    /**
     * Save the hashmap of timestamps into the plist file located in the 'Documents' directory.
     * @param { plist: Any} object to save.
     */
    static func savePropertyList(_ plist: Any)
    {
        do {
            let plistData = try PropertyListSerialization.data(fromPropertyList: plist, format: .xml, options: 0)
            try plistData.write(to: plistURL)
        } catch {
            #if DEBUG
                print(error)
            #endif
        }
    }
    
    /**
     * Loads the timestamp plist file located in the 'Documents' directory.
     * @returns { [String: [Double]] } Hashmap of event names to list of timestamps.
     * @throws error when plist file cannot be found.
     */
    static func loadPropertyList() throws -> [String: [Double]]
    {
        let data = try Data(contentsOf: plistURL)
        guard let plist = try PropertyListSerialization.propertyList(from: data, format: nil) as? [String: [Double]] else {
            return [String: [Double]]()
        }
        return plist
    }
}
