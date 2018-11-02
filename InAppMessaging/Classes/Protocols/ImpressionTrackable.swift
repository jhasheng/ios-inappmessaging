/**
 * Protocol that is conformed to when impression tracking is needed.
 */
protocol ImpressionTrackable {
    typealias Property = Attribute
    
    var impressions: [Impression] { get set }
    var properties: [Property] { get set }
    var campaign: CampaignData? { get set }
    
    /**
     *
     */
    func logImpression(withImpressionType type: ImpressionType, withProperties properties: [Property])
    
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
