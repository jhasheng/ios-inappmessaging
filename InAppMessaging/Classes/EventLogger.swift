/**
 * Struct to handle logging events by the host application.
 */
struct EventLogger: PlistManipulable {
    static var eventLog = [Event]()
    static var plistURL: URL {
        let documentDirectoryURL =  try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return documentDirectoryURL.appendingPathComponent(Keys.File.EventLogs)
    }
    
    /**
     * Log the event sent by the host application in a hashmap of event name to list of timestamps.
     * Saves into a plist file.
     * TODO(daniel.tam) Clear file when it is dumped to a server.
     * @param { eventName: String } name of the event sent by the host application.
     */
    static internal func logEvent(_ eventName: String) {
        
        // Check if there are any existing event logs stored locally.
        // Retrieve local logs if exists.
        if eventLog.isEmpty {
            do {
                eventLog = try loadPropertyList() ?? eventLog
            } catch {
                #if DEBUG
                    print("InAppMessaging: \(error)")
                #endif
            }
        }
        
        // Append Event object to the event log.
        eventLog.append(
            Event(
                name: eventName,
                timestamp: Date().millisecondsSince1970
            )
        )
        
        // Write to local storage.
        do {
            try savePropertyList(eventLog)
        } catch {
            #if DEBUG
                print("InAppMessaging: \(error)")
            #endif
        }
    }
    
    /**
     * Clear the in-memory eventLogs and the plist file.
     */
    static internal func clearLogs() {
        eventLog.removeAll()
        do {
            try self.deletePropertyList()
        } catch {
            #if DEBUG
                print("InAppMessaging: failed clearing event logs.")
            #endif
        }
    }
}
