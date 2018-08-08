/**
 * Utility struct to provide methods for anything campaign related.
 * Helps parse fore fields, map responses, and provide display logic.
 */
struct CampaignHelper {
    
    /**
     * Search through list of all campaigns' triggers to find the first matching campaign to return.
     * @param { trigger: String } The trigger name logged by the host app.
     * @param { campaignListOptional: [CampaignList]? } Optional array of the list of campaigns.
     * @returns { CampaignData? } Optional campaign with the matching trigger name.
     */
    static func findMatchingTrigger(trigger: String, campaignListOptional: [Campaign]?) -> CampaignData? {
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
    
    /**
     * Map campaign list returned by message mixer to a hashmap of trigger names to array of campaigns.
     * @param { campaignList: [Campaign] } list of campaign sent by Message Mixer server.
     * @returns { [String: [Campaign]] } Hashmap of event names to list of campaigns.
     */
    static func mapCampaign(campaignList: [Campaign]) -> [String: [Campaign]] {
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
    
    /**
     * Fetches a campaign based on two conditions -- campaign has not been shown before
     * and the event name matches.
     * @param { withEventName: String } name of the event to fetch.
     * @returns { CampaignData? } optional CampaignData that matches the two conditions.
     */
    static func fetchCampaign(withEventName: String) -> CampaignData? {
        if let campaignList = MessageMixerClient.campaignDict[withEventName] {
            for campaign in campaignList {
                if !self.isCampaignShown(campaignId: campaign.campaignData.campaignId) {
                    return campaign.campaignData
                }
            }
        }
        
        return nil
    }
    
    /**
     * Checks if the campaign has already been displayed or not based on the campaign ID.
     * @param { campaignId: String } ID of the campaign to check.
     * @returns { Bool } result of the check.
     */
    static func isCampaignShown(campaignId: String) -> Bool {
        return MessageMixerClient.listOfShownCampaigns.contains(campaignId)
    }
    
    /**
     * Method to append the campaign ID to the list of shown campaign IDs once it has been displayed once.
     * @param { campaignId: String } ID of the campaign to append.
     */
    static func appendShownCampaign(campaignId: String) {
        MessageMixerClient.listOfShownCampaigns.append(campaignId)
    }
    
    /**
     * Parses the campaign passed in for the view type. E.G modal/slideup/etc.
     * @param { campaign: CampaignData } campaign to parse through.
     * @returns { ViewType? } optional value of the view type field of the campaign.
     */
    static func findViewType(campaign: CampaignData) -> ViewType? {
        return ViewType(rawValue: campaign.type)
    }
}
