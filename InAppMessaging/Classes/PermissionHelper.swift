
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
        
        guard let subscriptionId = Bundle.inAppSubscriptionId,
            let campaignId = optionalParams!["campaignId"],
            let appVersion = Bundle.appBuildVersion,
            let sdkVersion = Bundle.inAppSdkVersion,
            let locale = Locale.formattedCode else {
                
                return nil
        }

        let permissionRequest = PermissionRequest.init(
            subscriptionId: subscriptionId,
            campaignId: campaignId as! String,
            userIdentifiers: IndentificationManager.userIdentifiers,
            platform: "iOS",
            appVersion: appVersion,
            sdkVersion: sdkVersion,
            locale: locale,
            events: EventLogger.eventLog)
        
        do {
            return try JSONEncoder().encode(permissionRequest)
        } catch {
            print("InAppMessaging: failed creating a request body.")
        }
        
        return nil
    }
    
}
