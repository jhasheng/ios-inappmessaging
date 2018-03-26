// Class to handle communication with the configuration server.

/**
 * Function that will parse the configuration server's response
 * for the enabled flag.
 * @returns { Optional Bool } value of the enabled flag.
 */
internal func checkConfigurationServer() -> Bool? {
    var enableSdk: Bool?
    
    // Fetch configuration server URL.
    if let configUrl = retrieveFromInfoPlist(forKey: "RakutenInsightsConfigURL"),
        let enabledFlagFromResponse = callConfigurationServer(withUrl: configUrl) {
            enableSdk = enabledFlagFromResponse
    } else {
        #if DEBUG
            assertionFailure("'RakutenInsightsConfigURL' is not valid.")
        #endif
    }
    
     return enableSdk
}

/**
 * Sends a POST request to configuration server.
 * @param { withUrl: String } configuration server URL.
 * @returns { Optional Bool } value of 'enabled' flag by config server.
 * (TODO: Daniel Tam) return endspoints also. (Bool?, [ String ]?)
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
            return enabled
        }
        
        // Semaphore added for synchronous HTTP calls.
        let semaphore = DispatchSemaphore(value: 0)

        // Start HTTP call.
        URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
            do {
                guard let data = data else {
                    print("Data returned is nil")
                    return
                }
                
                // Try to assign the data object from response body and convert to a JSON.
                guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject] else {
                    return
                }
                
                // Parse 'enabled' flag from response body.
                if let jsonData = json["data"],
                    let jsonEnabled = jsonData["enabled"] as? Bool {
                        enabled = jsonEnabled;
                }
            } catch let error {
                print("Error calling configuration server: \(error)")
                return
            }
            
            // Signal completion of HTTP request.
            semaphore.signal()
        }).resume()
        
        // Pause execution until signal() is called
        semaphore.wait()
    }

    return enabled
}

/**
 * Build out the request body for talking to configuration server.
 * @returns { Optional Data } of serialized JSON object with the required fields.
 */
fileprivate func buildHttpBody() -> Data? {
    
    // Assign all the variables required in request body to configuration server.
    guard let appId = retrieveFromMainBundle(forKey: "CFBundleIdentifier"),
        let appVersion = retrieveFromMainBundle(forKey: "CFBundleVersion"),
        let sdkVersion = retrieveFromInfoPlist(forKey: "RakutenInsightsSDKVersion") else {
        return nil
    }
    
    // Create the dictionary with the variables assigned above.
    let jsonDict: [String: Any] = [
        "app_id": appId,
        "platform": "iOS",
        "app_version": appVersion,
        "sdk_version": sdkVersion
    ]
    
    // Return the serialized JSON object.
    return try? JSONSerialization.data(withJSONObject: jsonDict)
}
