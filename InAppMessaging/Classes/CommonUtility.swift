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
    
    /**
     * Converts a Trigger object from Button object to a CustomEvent.
     * @param { trigger: Trigger } the trigger object to parse out.
     * @returns { Event? } the event object created the trigger object.
     */
    static func convertTriggerObjectToCustomEvent(_ trigger: Trigger) -> CustomEvent {
        var attributeList = [CustomAttribute]()
        
        for attribute in trigger.attributes {
            if let customAttribute = convertAttributeObjectToCustomAttribute(attribute) {
                attributeList.append(customAttribute)
            }
        }
        
        return CustomEvent(withName: trigger.eventName, withCustomAttributes: attributeList)
    }

    /**
     * Converts a TriggerAttribute into a CustomAttribute.
     * @param { attribute: TriggerAttribute } the trigger attribute to convert.
     * @returns { CustomAttribute? } the CustomAttribute object or nil.
     */
    static func convertAttributeObjectToCustomAttribute(_ attribute: TriggerAttribute) -> CustomAttribute? {
        switch attribute.type {
            case .INVALID:
                return nil
            case .STRING:
                return CustomAttribute(withKeyName: attribute.name, withStringValue: attribute.value)
            case .INTEGER:
                guard let value = Int(attribute.value) else {
                    #if DEBUG
                        print("InAppMessaging: Error converting value.")
                    #endif
                    return nil
                }
                
                return CustomAttribute(withKeyName: attribute.name, withIntValue: value)
            case .DOUBLE:
                guard let value = Double(attribute.value) else {
                    #if DEBUG
                        print("InAppMessaging: Error converting value.")
                    #endif
                    return nil
                }
                
                return CustomAttribute(withKeyName: attribute.name, withDoubleValue: value)
            case .BOOLEAN:
                guard let value = Bool(attribute.value) else {
                    #if DEBUG
                        print("InAppMessaging: Error converting value.")
                    #endif
                    return nil
                }
                
                return CustomAttribute(withKeyName: attribute.name, withBoolValue: value)
            case .TIME_IN_MILLI:
                guard let value = Int(attribute.value) else {
                    #if DEBUG
                        print("InAppMessaging: Error converting value.")
                    #endif
                    return nil
                }
                
                return CustomAttribute(withKeyName: attribute.name, withTimeInMilliValue: value)
        }
    }
}
