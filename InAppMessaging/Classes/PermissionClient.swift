/**
 * Struct to handle permission checking before displaying a campaign.
 */
struct PermissionClient: HttpRequestable {
    
    /**
     * Function that will handle communicating with the display-permission endpoint and handles the response.
     * By default, if anything goes wrong with the communication, return true and show the campaign.
     * @param { campaign: CampaignData } campaign that is about to be shown.
     * @returns { Bool } boolean to signal the SDK to either show or don't show the campaign.
     */
    func checkPermission(withCampaign campaign: CampaignData) -> Bool {
        
        let requestParams = [
            Keys.Request.CampaignID: campaign.campaignId
        ]
        
        // Call display-permission endpoint.
        guard let responseFromDisplayPermission =
            self.requestFromServer(
                withUrl: (ConfigurationClient.endpoints?.displayPermission)!,
                withHttpMethod: .post,
                withOptionalParams: requestParams) else {
                
                    return true
        }
        
        // Parse and handle the response.
        do {
            let decodedResponse = try JSONDecoder().decode(DisplayPermissionResponse.self, from: responseFromDisplayPermission)
            
            guard let permissionAction = PermissionAction(rawValue: decodedResponse.action) else {
                return true
            }
            
            switch permissionAction {
                case .invalid:
                    return true
                case .show:
                    executeShowAction(withCampaign: campaign)
                    return true
                case .discard:
                    executeDiscardAction(withCampaign: campaign)
                    return false
                case .postpone:
                    return false
                    break
            }
        } catch {
            #if DEBUG
                print("InAppMessaging: error getting a response from display permission.")
            #endif
        }
        
        return true
    }
    
    /**
     * This method will be executed when the display_permission endpoint returns a 'show' value.
     * This function, after showing the campaign, will then delete the campaignId from the list of campaign IDs.
     * @param { campaignData: CampaignData } data of the campaign that was permission checked.
     */
    fileprivate func executeShowAction(withCampaign campaignData: CampaignData) {
        
        // Append campaign ID to list of shown campaigns.
        CampaignHelper.appendShownCampaign(campaignId: campaignData.campaignId)
        
        // Delete the campaign from the campaign list feed.
        let triggerNames = createTriggerNameList(withCampaign: campaignData)
        if !triggerNames.isEmpty {
            CampaignHelper.deleteCampaign(withId: campaignData.campaignId, andTriggerNames: triggerNames)
        }
    }
    
    /**
     * This method will be executed when the display-permission endpoint returns a 'discard' value.
     * This function will just delete the campaignId from the list of campaign IDs.
     * @param { campaignData: CampaignData } data of the campaign that was permission checked.
     */
    fileprivate func executeDiscardAction(withCampaign campaignData: CampaignData) {
        // Delete the campaign from the campaign list feed.
        let triggerNames = createTriggerNameList(withCampaign: campaignData)
        if !triggerNames.isEmpty {
            CampaignHelper.deleteCampaign(withId: campaignData.campaignId, andTriggerNames: triggerNames)
        }
    }
    
    /**
     * In order to delete a campaignId from MessageMixer.mappedCampaigns, which potentially can have multiple occurences,
     * it will be more efficient if we already have a list of trigger names that the campaignId is mapped to.
     * This function generates that list of triggerNames that the campaign was previously mapped to.
     * @param { campaign: CampaignData } A specific campaign that includes all the trigger names that it was mapped to.
     * @returns { [String] } List of trigger names.
     */
    fileprivate func createTriggerNameList(withCampaign campaign: CampaignData) -> [String] {
        var triggerNames = [String]()
        for trigger in campaign.triggers {
            triggerNames.append(trigger.event)
        }
        
        return triggerNames
    }
    
    /**
     * Request body for display permission check.
     * @param { optionalParams: [String: Any]? } additional params to be added to the request body.
     * @returns { Data? } optional serialized data for the request body.
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
            #if DEBUG
                print("InAppMessaging: failed creating a request body.")
            #endif
        }
        
        return nil
    }
}
