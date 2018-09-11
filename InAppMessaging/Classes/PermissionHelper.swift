
struct PermissionHelper: HttpRequestable {
    
    func checkPermission(withCampaign campaign: [String: Any]) -> Bool {
        
        guard let responseFromDisplayPermission =
            self.requestFromServer(
                withUrl: (ConfigurationClient.endpoints?.displayPermission)!,
                withHttpMethod: .post,
                withOptionalParams: campaign) else {
                
                    return true
        }
        
        do {
            let decodedResponse = try JSONDecoder().decode(DisplayPermissionResponse.self, from: responseFromDisplayPermission)
            
            guard let permissionAction = PermissionAction(rawValue: decodedResponse.action) else {
                return true
            }
            
            //TODO(Daniel Tam) Add support for the actions in next PR.
            switch permissionAction {
                case .invalid:
                    return true
                case .show:
                    return true
                case .discard:
                    return false
                case .postpone:
                    break
            }
        } catch {
            print("InAppMessaging: error getting a response from display permission.")
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

        let permissionRequest = DisplayPermissionRequest.init(
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
