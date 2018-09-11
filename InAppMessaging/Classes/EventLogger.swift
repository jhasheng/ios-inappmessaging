/**
 * Struct to handle logging events by the host application.
 */
struct EventLogger: PlistManipulable {
//    static var eventLog = [String: [Any]]()
    static var eventLog = [Event]()
    static var plistURL: URL {
        let documentDirectoryURL =  try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        return documentDirectoryURL.appendingPathComponent(Keys.File.TimestampPlist)
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
        
        
        
//        if eventLog[eventName] != nil {
//            var tempLog = eventLog[eventName]
//            tempLog?.append(Date().timeIntervalSince1970)
//            eventLog[eventName] = tempLog
//        } else {
//            eventLog[eventName] = [Date().timeIntervalSince1970]
//        }
        
        do {
            try savePropertyList(eventLog)
        } catch {
            #if DEBUG
            print("InAppMessaging: \(error)")
            #endif
        }
    }
}
