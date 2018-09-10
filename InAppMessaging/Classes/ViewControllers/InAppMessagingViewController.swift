/**
 * Handle all the displaying logic of the SDK.
 */
class InAppMessagingViewController: UIViewController, HttpRequestable {
    
    /**
     * Contains logic to display the correct view type -- modal, slideup, fullscreen, html -- and create
     * a view controller to present.
     * @param { eventName: String } name of the event.
     */
    internal class func display(_ eventName: String) {
        
        // Fetch matching campaign and get its view type.
        guard let campaignToDisplay = CampaignHelper.fetchCampaign(withEventName: eventName),
            let campaignViewType = CampaignHelper.findViewType(campaign: campaignToDisplay) else {
            
                return
        }
        
        // Permission check here.
        let campaignInfo = [
            "campaignId": campaignToDisplay.campaignId,
            "event": eventName
        ]
        
        checkPermission(withCampaignInfo: campaignInfo)
        
        
        
        
        
        
        var view: Modal?

        // TODO(daniel.tam) Add the other view types.
        switch campaignViewType {
            case .modal:
                view = ModalView(campaign: campaignToDisplay)
                break
            case .invalid:
                break
            case .full:
                break
            case .slide:
                break
            case .html:
                break
        }
        
        // Display the campaign if the view exists and add the campaign ID to the shown ID list.
        if let viewToDisplay = view {
            viewToDisplay.show()
            CampaignHelper.appendShownCampaign(campaignId: campaignToDisplay.campaignId)
        }
    }
    
    internal class func checkPermission(withCampaignInfo campaignInfo: [String: Any]) -> Bool {
        
        
        return false
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
