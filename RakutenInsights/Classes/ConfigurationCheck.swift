internal func checkConfigurationServer() -> Bool {
    // Fetch infoplist
    if let configUrl = retrieveConfigurationURL() {
        // Request to config server
        print("valid")
    } else {
        #if DEBUG
            assertionFailure("'RakutenInsightsConfigURL' is not valid.")
        #endif
        return false
    }
    
    // Request to config server
    
    // Parse through config logic
    
     return false
}

/**
 * Retrieves configuration URL from Info.plist.
 * Key should be called "RakutenInsightsConfigURL"
 * Value must be a String type.
 * @returns { Optional String } configuration server URL.
 */
fileprivate func retrieveConfigurationURL() -> String? {
    var configServerUrl: String?
    var infoPlistDict: NSDictionary?

    if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
        infoPlistDict = NSDictionary(contentsOfFile: path)
    } else {
        #if DEBUG
            assertionFailure("Fail to locate Info.plist.")
        #endif
        return configServerUrl;
    }
    
    if let infoPlistContent = infoPlistDict, let optionalConfigServerUrl = infoPlistContent["RakutenInsightsConfigURL"] as? String {
        configServerUrl = optionalConfigServerUrl;
    } else {
        #if DEBUG
            assertionFailure("Please specify a 'RakutenInsightsConfigURL' key in Info.plist. Must be a String value.")
        #endif
    }

    return configServerUrl
}



