/**
 * Class to handle communication with the configuration server.
 */
class ConfigurationClient: HttpRequestable {
    
    static var endpoints: EndpointURL?
    
    /**
     * Function that will parse the configuration server's response
     * for the enabled flag. Return false by default.
     * @returns { Bool } value of the enabled flag.
     */
    internal func isConfigEnabled() -> Bool {
        
        guard let configUrl = Bundle.inAppConfigUrl else {
            #if DEBUG
                print("InAppMessaging: '\(Keys.URL.ConfigServerURL)' is not valid.")
            #endif
            
            return false
        }

        guard let responseData = self.request(withUrl: configUrl, withHTTPMethod: .post) else {
            print("InAppMessaging: Error calling server.")
            return false
        }
        
        return self.parseConfigResponse(configResponse: responseData)
    }
    
    /**
     * Parse the response retrieve from configuration server for the 'enabled' flag and endpoints.
     * @param { configResponse: [String: Any] } response as a dictionary equivalent.
     * @returns { Bool } the value of the 'enabled' flag.
     */
    func parseConfigResponse(configResponse: Data) -> Bool {
        var enabled: Bool = false
        
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(ConfigResponse.self, from: configResponse)
            
            if response.data.enabled {
                enabled = response.data.enabled
                ConfigurationClient.endpoints = response.data.endpoints
            }
            
        } catch let error {
            print("InAppMessaging: Failed to parse json:", error)
        }
        
        return enabled
    }
    
    internal func buildHttpBody() -> Data? {
        
        // Create the dictionary with the variables assigned above.
        let jsonDict: [String: Any] = [
            Keys.Request.AppID: Bundle.applicationId as Any,
            Keys.Request.Platform: "iOS",
            Keys.Request.AppVersion: Bundle.appBuildVersion as Any,
            Keys.Request.SDKVersion: Bundle.inAppSdkVersion as Any,
            Keys.Request.Locale: Locale.formattedCode as Any
        ]
        
        // Return the serialized JSON object.
        return try? JSONSerialization.data(withJSONObject: jsonDict)
    }
}
