/**
 * Handles hitting the impression endpoint.
 */
class ImpressionClient: HttpRequestable {
    typealias Property = Attribute
    
    /**
     * Keys for the optionalParams dictionary.
     */
    final let impressionKey = "impressions"
    final let propertyKey = "properties"
    final let campaignKey = "campaign"
    
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
        
            let optionalParams = [
                impressionKey: impressions,
                propertyKey: properties,
                campaignKey: campaign
                ] as [String : Any]
        
            guard let response = self.requestFromServer(
                withUrl: pingImpressionEndpoint,
                withHttpMethod: .post,
                withOptionalParams: optionalParams)
            else {
                return;
            }
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
            userIdentifiers: IndentificationManager.userIdentifiers
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
    
    
}
