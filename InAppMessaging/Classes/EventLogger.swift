/**
 * Struct to handle saving all the custom events for IAM's custom event endpoint and RAT.
 */
struct EventLogger: PlistManipulable {
    static var eventLog = [Event]()
    static var plistURL: URL {
        let documentDirectoryURL =  try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return documentDirectoryURL.appendingPathComponent(Keys.File.EventLogs)
    }
    
    /**
     * Log the event sent by the host application.
     * Saves into a plist file.
     * @param { eventName: String } name of the event sent by the host application.
     */
    static internal func logEvent(_ event: Event) {
        
        // Check if there are any existing event logs stored locally.
        // Retrieve local logs if exists.
        if eventLog.isEmpty {
            do {
                convertPropertyList(try loadPropertyList())
            } catch {
                // This will be called when a new property list is made.
            }
        }
        
        // Append only custom events.
        if event.eventType.rawValue == EventType.custom.rawValue {
            eventLog.append(event)
        }
        
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
                
                guard let eventType = plistObject[Keys.Event.eventType] as? Int else {
                    continue
                }
                
                switch eventType {
                    case 1:
                        guard let isUserLoggedIn = plistObject["isUserLoggedIn"] as? Bool,
                            let timestamp = plistObject["timestamp"] as? Int
                        else {
                            break
                        }
                    
                        eventLog.append(AppStartEvent.init(isUserLoggedIn: isUserLoggedIn, timestamp: timestamp))
                    
                    case 2:
                        guard let timestamp = plistObject["timestamp"] as? Int else {
                            break
                    }
                    
                        eventLog.append(LoginSuccessfulEvent.init(timestamp: timestamp))
                    
                    case 3:
                        guard let purchaseAmount = plistObject["purchaseAmount"] as? Int,
                            let numberOfitems = plistObject["numberOfItems"] as? Int,
                            let currencyCode = plistObject["currencyCode"] as? String,
                            let itemList = plistObject["itemList"] as? [String],
                            let timestamp = plistObject["timestamp"] as? Int
                        else {
                            break
                        }
                    
                        eventLog.append(
                            PurchaseSuccessfulEvent.init(
                                withPurchaseAmount: purchaseAmount,
                                withNumberOfItems: numberOfitems,
                                withCurrencyCode: currencyCode,
                                withItems: itemList,
                                timestamp: timestamp
                            )
                        )
                    
                    case 4:
                        guard let eventName = plistObject["eventName"] as? String,
                            let timestamp = plistObject["timestamp"] as? Int
                        else {
                            break
                        }
                    
                        eventLog.append(
                            CustomEvent.init(
                                withName: eventName,
                                timestamp: timestamp
                            )
                        )
                    default:
                        break
                }
            }
        }
    }
}
