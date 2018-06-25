/**
 *  Class that provides common utility methods for RakutenInAppMessaging module.
 */
class CommonUtility {
    
    /**
     * Retrieves the value of a specified key from main bundle.
     * @param { forKey: String } key of the property to extract value from.
     * @returns { Optional Any } value of the key property.
     */
    internal func retrieveFromMainBundle(forKey: String) -> Any? {
        guard let valueOfPropertyToRetrieve = Bundle.main.infoDictionary?[forKey] else {
            #if DEBUG
                print("InAppMessaging: Failed to retrieve '\(forKey)' from main bundle.")
            #endif
            return nil
        }
        
        return valueOfPropertyToRetrieve
    }
    
    /**
     * Builds the request header for HTTP calls.
     * @param { withURL: URL } contains the URL to call.
     * @param { withHTTPMethod: String } the HTTP method used. E.G "POST" / "GET"
     * @returns { URLRequest } URLRequest object with the specified HTTP method and added headers.
     */
    fileprivate func buildHTTPRequest(withURL: URL, HTTPMethod: String) -> URLRequest {
        var request = URLRequest(url: withURL)
        request.httpMethod = HTTPMethod
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
    /**
     * Generic method for calling an API.
     * @param { withUrl: String} the URL of the API to call.
     * @param { withHTTPMethod: String } the HTTP method used. E.G "POST" / "GET"
     * @returns { Optional [String: Any] } returns either nil or the response in a dictionary.
     */
    internal func callServer(withUrl: String, withHTTPMethod: String) -> [String: Any]? {
        var dataToReturn: [String: Any]?
        
        if let url = URL(string: withUrl) {
            
            // Add in the HTTP headers.
            var request = self.buildHTTPRequest(withURL: url, HTTPMethod: withHTTPMethod)
            request.httpBody = self.buildHttpBody()
            
            // Semaphore added for synchronous HTTP calls.
            let semaphore = DispatchSemaphore(value: 0)
            
            // Start HTTP call.
            URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
                do {
                    guard let data = data else {
                        print("Data returned is nil")
                        semaphore.signal()
                        return
                    }
                    
                    // Try to assign the data object from response body and convert to a JSON.
                    guard let jsonData = try JSONSerialization
                        .jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                            semaphore.signal()
                            return
                    }
                    
                    dataToReturn = jsonData
                    
                } catch let error {
                    print("Error calling the server: \(error)")
                    semaphore.signal()
                    return
                }
                
                // Signal completion of HTTP request.
                semaphore.signal()
            }).resume()
            
            // Pause execution until signal() is called
            semaphore.wait()
        }
        
        return dataToReturn
    }
    
    /**
     * Build out the request body for talking to configuration server.
     * @returns { Optional Data } of serialized JSON object with the required fields.
     */
    fileprivate func buildHttpBody() -> Data? {
        
        // Assign all the variables required in request body to configuration server.
        guard let appId = self.retrieveFromMainBundle(forKey: "CFBundleIdentifier"),
            let appVersion = self.retrieveFromMainBundle(forKey: "CFBundleVersion"),
            let sdkVersion = self.retrieveFromMainBundle(forKey: "InAppMessagingSDKVersion"),
            let locale = "\(Locale.current)".components(separatedBy: " ").first else {
                
                return nil
        }
                
        // Create the dictionary with the variables assigned above.
        let jsonDict: [String: Any] = [
            Keys.Request.AppID: appId,
            Keys.Request.Platform: "iOS",
            Keys.Request.AppVersion: appVersion,
            Keys.Request.SDKVersion: sdkVersion,
            Keys.Request.Locale: locale
        ]
        
        // Return the serialized JSON object.
        return try? JSONSerialization.data(withJSONObject: jsonDict)
    }
}
