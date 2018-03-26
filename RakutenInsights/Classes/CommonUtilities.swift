// Helper methods to provide common utlity methods for the module.

/**
 * Retrieves the value of a specified key from Info.plist.
 * @param { forKey: String } key of the property to extract value from.
 * @returns { Optional String } value of the key property.
 */
internal func retrieveFromInfoPlist(forKey: String) -> String? {
    var valueOfPropertyToRetrieve: String?
    var infoPlistDict: NSDictionary?
    
    if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
        infoPlistDict = NSDictionary(contentsOfFile: path)
    } else {
        #if DEBUG
            assertionFailure("Fail to locate Info.plist.")
        #endif
        return valueOfPropertyToRetrieve;
    }
    
    if let infoPlistContent = infoPlistDict,
        let optionalValueOfPropertyToRetrieve = infoPlistContent[forKey] as? String {
        valueOfPropertyToRetrieve = optionalValueOfPropertyToRetrieve;
    } else {
        #if DEBUG
            assertionFailure("Please specify a '\(forKey)' key in Info.plist. Must be a String value.")
        #endif
    }
    
    return valueOfPropertyToRetrieve
}

/**
 * Retrieves the value of a specified key from main bundle.
 * @param { forKey: String } key of the property to extract value from.
 * @returns { Optional String } value of the key property.
 */
internal func retrieveFromMainBundle(forKey: String) -> String? {
    guard let valueOfPropertyToRetrieve = Bundle.main.infoDictionary?[forKey]  as? String else {
        #if DEBUG
            assertionFailure("Failed to retrieve '\(forKey)' from main bundle.")
        #endif
        return nil
    }
    
    return valueOfPropertyToRetrieve
}
