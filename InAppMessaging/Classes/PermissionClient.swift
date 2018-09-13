struct PermissionClient: HttpRequestable {
    
    func checkPermission(withCampaign campaign: CampaignData) -> Bool {
        
        let requestParams = [
            Keys.Request.CampaignID: campaign.campaignId
        ]
        
        guard let responseFromDisplayPermission =
            self.requestFromServer(
                withUrl: (ConfigurationClient.endpoints?.displayPermission)!,
                withHttpMethod: .post,
                withOptionalParams: requestParams) else {
                
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
     * This method will be executed when the display_permission endpoint returns a 'show' value.
     * This function will show the campaign and then delete the campaignId from the list of campaign IDs.
     */
    fileprivate func executeShowAction() {
        
    }
    
    /**
     * Request body for display permission check.
     */
    internal func buildHttpBody(withOptionalParams optionalParams: [String: Any]?) -> Data? {
        
        guard let subscriptionId = Bundle.inAppSubscriptionId,
            let campaignId = optionalParams![Keys.Request.CampaignID],
            let appVersion = Bundle.appBuildVersion,
            let sdkVersion = Bundle.inAppSdkVersion,
            let locale = Locale.formattedCode else {
                
                #if DEBUG
                    print("InAppMessaging: error while building request body for display_permssion.")
                #endif
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
