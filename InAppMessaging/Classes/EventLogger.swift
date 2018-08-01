/**
 * Struct to handle logging events by the host application.
 */
struct EventLogger: EventLoggerProtocol {
    static var eventLog = [String: [Double]]()
    static var plistURL: URL {
        let documentDirectoryURL =  try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        return documentDirectoryURL.appendingPathComponent(Keys.File.TimestampPlist)
    }
    
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
}
