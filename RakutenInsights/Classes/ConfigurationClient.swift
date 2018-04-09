/**
 * Class to handle communication with the configuration server.
 */
class ServerConfiguration {
    
    let commonUtility: CommonUtility
    
    init(commonUtility: CommonUtility) {
        self.commonUtility = commonUtility
    }
    
    /**
     * Function that will parse the configuration server's response
     * for the enabled flag. Return false by default.
     * @returns { Bool } value of the enabled flag.
     */
    internal func checkConfigurationServer() -> Bool {
        guard let configUrl = commonUtility.retrieveFromMainBundle(forKey: "RakutenInsightsConfigURL") as? String else {
            #if DEBUG
                print("RakutenInsights: 'RakutenInsightsConfigURL' is not valid.")
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
     * @param { configResponse: [String: AnyObject] } response as a dictionary equivalent.
     * @returns { Bool } the value of the 'enabled' flag.
     */
    fileprivate func parseConfigResponse(configResponse: [String: AnyObject]) -> Bool {
        var enabled: Bool = false

        if let jsonData = configResponse["data"],
            let enabledFlag = jsonData["enabled"] as? Bool {
            enabled = enabledFlag;
        }
        
        return enabled
    }
}
