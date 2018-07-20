/**
 * Utility class to provide methods for anything campaign related.
 * Helps parse fore fields, map responses, and provide display logic.
 */
class CampaignHelper {
    
    /**
     * Search through list of all campaigns' triggers to find the first matching campaign to return.
     * @param { trigger: String } The trigger name logged by the host app.
     * @param { campaignListOptional: [CampaignList]? } Optional array of the list of campaigns.
     * @returns { CampaignData? } Optional campaign with the matching trigger name.
     */
    internal func findMatchingTrigger(trigger: String, campaignListOptional: [Campaign]?) -> CampaignData? {
        guard let campaignList = campaignListOptional else {
            return nil
        }
        
        for campaign in campaignList {
            for campaignTrigger in campaign.campaignData.triggers {
                if trigger == campaignTrigger.event {
                    return campaign.campaignData
                }
            }
        }

        return nil
    }
    
    internal func findViewType(campaign: CampaignData) -> String? {
        return campaign.type
    }
    
    /**
     * Map campaign list returned by message mixer to a hashmap of trigger names to array of campaign.
     */
    internal func mapCampaign(campaignList: [Campaign]) -> [String: [Campaign]] {
        var campaignDict = [String: [Campaign]]()
        
        for campaign in campaignList {
            for campaignTrigger in campaign.campaignData.triggers {
                
                let triggerName = campaignTrigger.event
                
                if campaignDict[triggerName] != nil {
                    campaignDict[triggerName]?.append(campaign)
                } else {
                    campaignDict[triggerName] = [campaign]
                }
            }
        }
        
        return campaignDict
    }
    
    internal func fetchCampaign(withEventName: String) -> CampaignData? {
        if let campaignList = MessageMixerClient.campaignDict[withEventName] {
            for campaign in campaignList {
                if !self.isCampaignShown(campaignId: campaign.campaignData.campaignId) {
                    return campaign.campaignData
                }
            }
        }
        
        return nil
    }
        
    internal func isCampaignShown(campaignId: String) -> Bool {
        return MessageMixerClient.listOfShownCampaigns.contains(campaignId)
    }
    
    internal func appendShownCampaign(campaignId: String) {
        MessageMixerClient.listOfShownCampaigns.append(campaignId)
    }
}
