/**
 * Handles hitting the impression endpoint.
 */
class ImpressionClient: HttpRequestable, AnalyticsBroadcaster {
    typealias Property = Attribute
    
    /**
     * Keys for the optionalParams dictionary.
     */
    final let impressionKey = "impressions"
    final let propertyKey = "properties"
    final let campaignKey = "campaign"
    
    /**
     * Retrieves the impression URL and sends it to the backend.
     * Packs up neccessary data to create the request body.
     * @param { impressions: [Impression] } list of impressions to send.
     * @param { properties: [Property] } list of properties to send.
     * @param { campaign: CampaignData } campaign data to parse for fields.
     */
    func pingImpression(
        withImpressions impressions: [Impression],
        withProperties properties: [Property],
        withCampaign campaign: CampaignData) {
        
            guard let pingImpressionEndpoint = ConfigurationClient.endpoints?.impression else {
                #if DEBUG
                    print("InAppMessaging: Error retrieving InAppMessaging Impression URL")
                #endif
                return
            }
        
            let optionalParams: [String : Any] = [
                impressionKey: impressions,
                propertyKey: properties,
                campaignKey: campaign
            ]
        
            // Broadcast impression data to RAnalytics.
            self.sendEventName(
                Keys.RAnalytics.impressions,
                ["impressions": deconstructImpressionObject(impressionList: impressions)]
            )
        
            // Send impression data back to impression endpoint.
            self.requestFromServer(
                withUrl: pingImpressionEndpoint,
                withHttpMethod: .post,
                withOptionalParams: optionalParams,
                withAdditionalHeaders: buildRequestHeader())
    }
    
    /**
     * Deconstruct impression object list to send back to RAnalytics.
     * This is to solve the issue where RAnalytics cannot take in IAM's custom objects.
     * @param { impressionList: [Impression] } array of impression objects.
     * @returns { [Any] } array of primitive impression values.
     */
    func deconstructImpressionObject(impressionList: [Impression]) -> [Any] {
        var resultList = [Any]()
        
        for impression in impressionList {
            var tempImpression = [String: Any]()
            tempImpression["ACTION"] =  impression.type.rawValue
            tempImpression["ts"] = impression.ts
            
            resultList.append(tempImpression)
        }
        
        return resultList
    }
    
    /**
     * Build the request body for hitting the impression endpoint.
     */
    func buildHttpBody(withOptionalParams optionalParams: [String : Any]?) -> Data? {
        
        guard let params = optionalParams,
            let impressions = params[impressionKey] as? [Impression],
            let properties = params[propertyKey] as? [Property],
            let campaign = params[campaignKey] as? CampaignData,
            let subscriptionId = Bundle.inAppSubscriptionId,
            let appVersion = Bundle.appBuildVersion,
            let sdkVersion = Bundle.inAppSdkVersion
        else {
            #if DEBUG
                print("InAppMessaging: Error building impressions request body.")
            #endif
            return nil
        }
        
        let impressionRequest = ImpressionRequest(
            campaignId: campaign.campaignId,
            isTest: campaign.isTest,
            subscriptionId: subscriptionId,
            appVersion: appVersion,
            sdkVersion: sdkVersion,
            properties: properties,
            impressions: impressions,
            userIdentifiers: IAMPreferenceRepository.getUserIdentifiers()
        )
        
        do {
            return try JSONEncoder().encode(impressionRequest)
        } catch {
            #if DEBUG
                print("InAppMessaging: Error encoding impression request.")
            #endif
        }

        return nil
    }
    
    fileprivate func buildRequestHeader() -> [Attribute] {
        var additionalHeaders: [Attribute] = []
        
        // Retrieve sub ID and return in header of the request.
        if let subId = Bundle.inAppSubscriptionId {
            additionalHeaders.append(Attribute(withKeyName: Keys.Request.subscriptionHeader, withValue: subId))
        }
        
        // Retrieve access token and return in the header of the request.
        if let accessToken = IAMPreferenceRepository.getAccessToken() {
            additionalHeaders.append(Attribute(withKeyName: Keys.Request.authorization, withValue: "OAuth2 \(accessToken)"))
        }
        
        return additionalHeaders
    }
}
