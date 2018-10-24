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
    static internal func logEvent(_ event: Event) {
        
        // Check if there are any existing event logs stored locally.
        // Retrieve local logs if exists.
        if eventLog.isEmpty {
            do {
                convertPropertyList(try loadPropertyList())
            } catch {
                #if DEBUG
                    print("InAppMessaging: \(error)")
                #endif
            }
        }
        
        // Append Event object to the event log.
        eventLog.append(event)
        
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
    
    /**
     * Converts the array of un-decoded Event objects from the plist into actual Event objects.
     * This is due to a bug that causes data loss when decoding a subclass straight from
     * a data type. In this case, we cannot decode pre-defined events properly.
     * More information: https://stackoverflow.com/questions/44553934/using-decodable-in-swift-4-with-inheritance
     * This method will append these Event objects to the eventLog.
     * @param { plistArrayOptional: [[String: Any]] } the optional array that is returned by deserializing the plist.
     */
    static internal func convertPropertyList(_ plistArrayOptional: [[String: Any]]?) {
        
        if let plistArray = plistArrayOptional {
            for plistObject in plistArray {
                
                guard let eventType = plistObject[Keys.Event.eventType] as? Int,
                    let timestamp = plistObject[Keys.Event.timestamp] as? Int,
                    let eventName = plistObject[Keys.Event.eventName] as? String
                else {
                        return
                }
                
                let customAttributes: [String: String]? = plistObject[Keys.Event.customAttributes] as? [String: String]
                
                let event = Event(eventType: EventType(rawValue: eventType)!, eventName: eventName, customAttributes: customAttributes)
                event.timestamp = timestamp
                eventLog.append(event)
            }
        }
    }
}
