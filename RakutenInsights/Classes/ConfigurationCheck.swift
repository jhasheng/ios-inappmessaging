internal func checkConfigurationServer() -> Bool {
    // Fetch infoplist
    if let configUrl: String = retrieveConfigurationUrl() {
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
 * Key should be called "RakutenInsightsConfigURL"
 * Value must be a String type.
 * @returns { Optional String } configuration server URL.
 */
fileprivate func retrieveConfigurationUrl() -> String? {
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

/**
 *
 */
fileprivate func callConfigurationServer(withUrl: String) {
    
    
    if let url = URL(string: withUrl) {
        
        var enabled: Bool?
        var endpoints: NSDictionary?
        
        // Add in the HTTP headers.
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with:url, completionHandler: {(data, response, error) in
            
            do {
                guard let data = data else {
                    print("Data returned is nil")
                    return
                }
                
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else {
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



