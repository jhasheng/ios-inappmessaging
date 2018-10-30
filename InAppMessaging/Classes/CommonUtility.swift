/**
 *  Struct that provides common utility methods for RakutenInAppMessaging module.
 */
struct CommonUtility {
    
    /**
     * Convert Data type responses to [String: Any]? type.
     */
    static func convertDataToDictionary(_ data: Data) -> [String: Any]? {
        var dataToReturn: [String: Any]?
        
        do {
            guard let jsonData = try JSONSerialization
                .jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                    return nil
            }
            
            dataToReturn = jsonData
        } catch let error {
            print("InAppMessaging: Error converting data: \(error)")
            return nil
        }
        
        return dataToReturn
    }
    
    /**
     * Provides a way to lock objects when performing a function.
     * @param { objects: [AnyObject] } list of objects to lock.
     * @param { pingResponse: PingResponse } new ping response to reconciliate.
     * @param { closure: () -> () } the function to perform with the objects locked.
     */
    static func lock(objects: [AnyObject], pingResponse: PingResponse, closure: (_ pingResponse: PingResponse) -> ()) {
        // Lock all the objects passed in.
        for object in objects {
            objc_sync_enter(object)
        }
        
        // Run closure.
        closure(pingResponse)
        
        // Unlock all the objects when done.
        for object in objects {
            objc_sync_exit(object)
        }
    }
    
    /**
     * Provides a way to lock objects when performing a function.
     * @param { objects: [AnyObject] } list of objects to lock.
     * @param { closure: () -> () } the function to perform with the objects locked.
     */
    static func lock(objects: [AnyObject], closure: () -> ()) {
        // Lock all the objects passed in.
        for object in objects {
            objc_sync_enter(object)
        }
        
        // Run closure.
        closure()
        
        // Unlock all the objects when done.
        for object in objects {
            objc_sync_exit(object)
        }
    }
}
