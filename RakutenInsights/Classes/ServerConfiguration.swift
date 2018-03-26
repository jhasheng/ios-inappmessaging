internal func checkConfigurationServer() -> Bool {
    // Fetch infoplist
    if let configUrl: String = retrieveFromInfoPlist(forKey: "RakutenInsightsConfigURL") {
        // Request to config server
        print("valid")
        callConfigurationServer(withUrl: configUrl)
    } else {
        #if DEBUG
            assertionFailure("'RakutenInsightsConfigURL' is not valid.")
        #endif
        return false
    }
    
    // Parse through config logic
    
     return false
}

/**
 * Retrieves configuration URL from Info.plist.
 * @param { forKey: String } key of the property to extract value from.
 * @returns { Optional String } value of the key property.
 */
fileprivate func retrieveFromInfoPlist(forKey: String) -> String? {
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
 * Sends a POST request to configuration server.
 * @param { withUrl: String } configuration server URL.
 */
fileprivate func callConfigurationServer(withUrl: String) {
    if let url = URL(string: withUrl) {
        var enabled: Bool?
        var endpoints: NSDictionary?
        
        // Add in the HTTP headers.
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = buildJSONBody()
        
        URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
            do {
                guard let data = data else {
                    print("Data returned is nil")
                    return
                }
                
                guard let json = try JSONSerialization.jsonObject(with: data) as? NSDictionary else {
                    return
                }
                print(json) // TESTING
            } catch let error {
                print("Error calling configuration server: \(error)")
                return
            }
        }).resume()
    }
}

fileprivate func buildJSONBody() -> Data? {
    
    guard let appId = getAppId() else {
        return nil
    }
    
    guard let appVersion = getAppVersion() else {
        return nil
    }
    
    let json: [String: Any] = [
        "app_id": appId,
        "platform": "iOS",
        "sdk_version": "0.1.0" // Temp. Is this specified by the user?
    ]
    
    print(JSONSerialization.isValidJSONObject(json))
    
    return nil
}
