/**
 * Class to handle communication with the configuration server.
 */
class ConfigurationClient: HttpRequestable {
    
    private static var delay: Int = 0
    static var endpoints: EndpointURL?
    
    /**
     * Function that will parse the configuration server's response
     * for the enabled flag. Return false by default.
     * @returns { Bool } value of the enabled flag.
     */
    internal func isConfigEnabled() -> Bool {
        
        guard let configUrl = Bundle.inAppConfigUrl else {
            #if DEBUG
                assertionFailure("InAppMessaging: '\(Keys.URL.ConfigServerURL)' is not valid.")
            #endif
            
            return false
        }

        guard let responseData = self.requestFromServer(withUrl: configUrl, withHttpMethod: .post) else {
            print("InAppMessaging: Error calling server.")
            // Exponential backoff for pinging Configuration server.
            ConfigurationClient.delay = (ConfigurationClient.delay == 0) ? 10000 : ConfigurationClient.delay * 2
            WorkScheduler.scheduleTask(ConfigurationClient.delay, closure: InAppMessaging.configure)
            return false
        }
        
        return self.parseConfigResponse(configResponse: responseData)
    }
    
    /**
     * Parse the response retrieve from configuration server for the 'enabled' flag and endpoints.
     * @param { configResponse: [String: Any] } response as a dictionary equivalent.
     * @returns { Bool } the value of the 'enabled' flag.
     */
    internal func parseConfigResponse(configResponse: Data) -> Bool {
        var enabled: Bool = false
        
        do {
            let response = try JSONDecoder().decode(GetConfigResponse.self, from: configResponse)
            
            if response.data.enabled {
                enabled = response.data.enabled
                ConfigurationClient.endpoints = response.data.endpoints
            }
            
        } catch let error {
            print("InAppMessaging: Failed to parse json:", error)
        }
        
        return enabled
    }
    
    /**
     * Request body for Configuration client to get get-config endpoint.
     * @param { optionalParams: [String: Any]? } additional params to be added to the request body.
     * @returns { Data? } optional serialized data for the request body.
     */
    internal func buildHttpBody(withOptionalParams optionalParams: [String: Any]?) -> Data? {
        
        guard let locale = Locale.formattedCode,
            let appVersion = Bundle.appBuildVersion,
            let appId = Bundle.applicationId,
            let sdkVersion = Bundle.inAppSdkVersion
        else {
            #if DEBUG
                assertionFailure("InAppMessaging: Make sure there is a valid 'InAppMessagingSDKVersion' key in your info.plist.")
            #endif
            return nil
        }
        
        let getConfigRequest = GetConfigRequest.init(
            locale: locale,
            appVersion: appVersion,
            platform: "iOS",
            appId: appId,
            sdkVersion: sdkVersion
        )
        
        do {
            return try JSONEncoder().encode(getConfigRequest)
        } catch {
            print("InAppMessaging: failed creating a request body.")
        }
        return nil
    }
}
