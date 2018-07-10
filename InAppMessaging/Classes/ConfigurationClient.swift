/**
 * Class to handle communication with the configuration server.
 */
class ConfigurationClient {
    
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
        
//        guard let response = commonUtility.convertDataToDictionary(responseData) else {
//            print("Error converting response.")
//            return false
//        }
        
        return parseConfigResponse(configResponse: responseData)
    }
    
    /**
     * Parse the response retrieve from configuration server for the 'enabled' flag.
     * @param { configResponse: [String: Any] } response as a dictionary equivalent.
     * @returns { Bool } the value of the 'enabled' flag.
     * (TODO: Daniel Tam) Parse for endpoints.
     */
    fileprivate func parseConfigResponse(configResponse: Data) -> Bool {
        var enabled: Bool = false
        
        

//        if let jsonData = configResponse["data"] as? [String: Any],
//            let enabledFlag = jsonData["enabled"] as? Bool {
//            enabled = enabledFlag;
//        }
        
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(ConfigResponse.self, from: configResponse)
            
            print(response)
        } catch let error {
            print("Failed to parse json:", error)
        }
        
        
        /**
        do {
            let decoder = JSONDecoder()
            MessageMixerClient.sharedInstance.campaign = try decoder.decode(CampaignResponse.self, from: response).data
            let nextPing = try decoder.decode(CampaignResponse.self, from: response).nextPing
            schedulePingToMixerServer(nextPing)
        } catch let error {
            print("Failed to parse json:", error)
        }
        */
        
        return enabled
    }
}
