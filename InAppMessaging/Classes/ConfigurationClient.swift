/**
 * Class to handle communication with the configuration server.
 */
struct ConfigurationClient {
    
    static var endpoints: EndpointURL?
    
    /**
     * Function that will parse the configuration server's response
     * for the enabled flag. Return false by default.
     * @returns { Bool } value of the enabled flag.
     */
    internal func isConfigEnabled() -> Bool {
        let configUrlKey = Keys.URL.ConfigServerURL
        let commonUtility = InjectionContainer.container.resolve(CommonUtility.self)!
        
        guard let configUrl = commonUtility.retrieveFromMainBundle(forKey: configUrlKey) as? String else {
            #if DEBUG
                print("InAppMessaging: '\(configUrlKey)' is not valid.")
            #endif
            
            return false
        }
        
        guard let responseData = commonUtility.callServer(withUrl: configUrl, withHTTPMethod: "POST") else {
            print("Error calling server.")
            return false
        }
        
        return parseConfigResponse(configResponse: responseData)
    }
    
    /**
     * Parse the response retrieve from configuration server for the 'enabled' flag and endpoints.
     * @param { configResponse: [String: Any] } response as a dictionary equivalent.
     * @returns { Bool } the value of the 'enabled' flag.
     */
    fileprivate func parseConfigResponse(configResponse: Data) -> Bool {
        var enabled: Bool = false
        
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(ConfigResponse.self, from: configResponse)
            
            if response.data.enabled {
                enabled = response.data.enabled
                ConfigurationClient.endpoints = response.data.endpoints
            }
            
        } catch let error {
            print("Failed to parse json:", error)
        }
        
        return enabled
    }
}
