
struct PermissionHelper: HttpRequestable {
    
    func checkPermission(withCampaignInfo campaignInfo: [String: Any]) -> Bool {
        
        guard let responseFromDisplayPermission =
            self.requestFromServer(
                withUrl: (ConfigurationClient.endpoints?.displayPermission)!,
                withHttpMethod: .post,
                withOptionalParams: campaignInfo) else {
                
                    return true
        }
        
        
        return true
    }
    
    /**
     * Request body for display permission check.
     */
    internal func buildHttpBody(withOptionalParams optionalParams: [String: Any]?) -> Data? {
        
        // Create the dictionary with the variables assigned above.
        var jsonDict = optionalParams ?? [:]
        
        jsonDict[Keys.Request.SubscriptionID] = Bundle.inAppSubscriptionId
        jsonDict[Keys.Request.UserIdentifiers] = IndentificationManager.userIdentifiers
        jsonDict[Keys.Request.AppID] = Bundle.applicationId
        jsonDict[Keys.Request.Platform] = "iOS"
        jsonDict[Keys.Request.AppVersion] = Bundle.appBuildVersion
        jsonDict[Keys.Request.SDKVersion] = Bundle.inAppSdkVersion
        jsonDict[Keys.Request.Locale] = Locale.formattedCode
        
        // Return the serialized JSON object.
        return try? JSONSerialization.data(withJSONObject: jsonDict)
    }
    
}
