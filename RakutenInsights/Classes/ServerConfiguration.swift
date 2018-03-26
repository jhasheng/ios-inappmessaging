internal func checkConfigurationServer() -> Bool? {
    var enableSDK: Bool?
    
    // Fetch infoplist
    if let configUrl: String = retrieveFromInfoPlist(forKey: "RakutenInsightsConfigURL") {
        // Request to config server
        if let optionalEnableSDK = callConfigurationServer(withUrl: configUrl) {
            enableSDK = optionalEnableSDK
        }
    } else {
        #if DEBUG
            assertionFailure("'RakutenInsightsConfigURL' is not valid.")
        #endif
        return enableSDK
    }
    
    // Parse through config logic
    
     return enableSDK
}

/**
 * Sends a POST request to configuration server.
 * @param { withUrl: String } configuration server URL.
 * @returns { Optional Bool } value of 'enabled' flag by config server. nil if error.
 */
fileprivate func callConfigurationServer(withUrl: String) -> Bool? {
    var enabled: Bool?
    
    if let url = URL(string: withUrl) {
        var endpoints: NSDictionary?
        
        // Add in the HTTP headers.
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let requestBody = buildHttpBody() {
            request.httpBody = requestBody
        } else {
            // Fail to contact config server.
        }
        
        let semaphore = DispatchSemaphore(value: 0)

        URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
            do {
                guard let data = data else {
                    print("Data returned is nil")
                    return
                }
                
                guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject] else {
                    return
                }
                if let jsonData = json["data"],
                    let jsonEnabled = jsonData["enabled"] as? Bool {
                        enabled = jsonEnabled;
                }
                
            } catch let error {
                print("Error calling configuration server: \(error)")
                return
            }
            
            semaphore.signal()
        }).resume()
        
        semaphore.wait()
    }

    return enabled
}

/**
 * Build out the request body for talking to configuration server.
 * @returns { Optional Data } of serialized JSON object with the required fields.
 */
fileprivate func buildHttpBody() -> Data? {
    
    guard let appId = retrieveFromMainBundle(forKey: "CFBundleIdentifier"),
        let appVersion = retrieveFromMainBundle(forKey: "CFBundleVersion"),
        let sdkVersion = retrieveFromInfoPlist(forKey: "RakutenInsightsSDKVersion") else {
        return nil
    }
    
    let jsonDict: [String: Any] = [
        "app_id": appId,
        "platform": "iOS",
        "app_version": appVersion,
        "sdk_version": sdkVersion
    ]
    
    return try? JSONSerialization.data(withJSONObject: jsonDict)
}
