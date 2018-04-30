/**
 * Class to handle communication with the configuration server.
 */
class ConfigurationClient {
    
    private let commonUtility: CommonUtility
    
    init(commonUtility: CommonUtility) {
        self.commonUtility = commonUtility
    }
    
    /**
     * Function that will parse the configuration server's response
     * for the enabled flag. Return false by default.
     * @returns { Bool } value of the enabled flag.
     */
    internal func checkConfigurationServer() -> Bool {
        guard let configUrl = commonUtility.retrieveFromMainBundle(forKey: "InAppMessagingConfigURL") as? String else {
            #if DEBUG
                print("InAppMessaging: 'InAppMessagingConfigURL' is not valid.")
            #endif
            
            return false
        }
        
        guard let response = commonUtility.callServer(withUrl: configUrl, withHTTPMethod: "POST") else {
            print("Error calling server")
            return false
        }
        
        return parseConfigResponse(configResponse: response)
    }
    
    /**
     * Parse the response retrieve from configuration server for the 'enabled' flag.
     * @param { configResponse: [String: Any] } response as a dictionary equivalent.
     * @returns { Bool } the value of the 'enabled' flag.
     * (TODO: Daniel Tam) Parse for endpoints.
     */
    fileprivate func parseConfigResponse(configResponse: [String: Any]) -> Bool {
        var enabled: Bool = false

        if let jsonData = configResponse["data"] as? [String: Any],
            let enabledFlag = jsonData["enabled"] as? Bool {
            enabled = enabledFlag;
        }
        
        return enabled
    }
}
