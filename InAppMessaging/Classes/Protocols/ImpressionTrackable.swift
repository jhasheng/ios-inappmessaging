/**
 * Protocol that is conformed to when impression tracking is needed.
 */
protocol ImpressionTrackable {
    typealias Property = Attribute
    
    var impressions: [Impression] { get set }
    var properties: [Property] { get set }
    var campaign: CampaignData? { get set }
    
    /**
     * Log the impression of a campaign.
     * @param { type: ImpressionType } enum type of the impression.
     * @param { properties: [Property] } optional properties to send.
     */
    func logImpression(withImpressionType type: ImpressionType, withProperties properties: [Property])
    
    /**
     * Called at the end of an action function from a campaign. This will pack
     * up all the neccessary data and send it to the impression endpoint.
     */
    func sendImpression()
    
}

extension ImpressionTrackable {
    func sendImpression() {
    
        guard let campaign = self.campaign else {
            #if DEBUG
                print("InAppMessaging: Error sending impression.")
            #endif
            return
        }
        
        ImpressionClient().pingImpression(
            withImpressions: impressions,
            withProperties: properties,
            withCampaign: campaign)
    }
}
