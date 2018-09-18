/**
 * Utility struct to provide methods for anything campaign related.
 * Helps parse fore fields, map responses, and provide display logic.
 */
struct CampaignHelper {
    
    /**
     * Map campaign list returned by message mixer to a hashmap of trigger names to array of campaigns.
     * @param { campaignList: Set<Campaign> } list of campaign sent by Message Mixer server.
     * @returns { [String: Set<Campaign>] } Hashmap of event names to list of campaigns.
     */
    static func mapCampaign(campaignList: Set<Campaign>) -> [String: Set<Campaign>] {
        var campaignDict = [String: Set<Campaign>]()
        
        for campaign in campaignList {
            for campaignTrigger in campaign.campaignData.trigger.conditions {
                
                let triggerName = campaignTrigger.event
                
                if campaignDict[triggerName] != nil {
                    campaignDict[triggerName]?.insert(campaign)
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
        if let campaignList = MessageMixerClient.mappedCampaigns[withEventName] {
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
        MessageMixerClient.listOfShownCampaigns.insert(campaignId)
    }
    
    /**
     * Parses the campaign passed in for the view type. E.G modal/slideup/etc.
     * @param { campaign: CampaignData } campaign to parse through.
     * @returns { CampaignDisplayType? } optional value of the view type field of the campaign.
     */
    static func findViewType(campaign: CampaignData) -> CampaignDisplayType? {
        return CampaignDisplayType(rawValue: campaign.type)
    }
    
    /**
     * Parses through the dictionary of trigger names to campaigns and delete the campaign from the whole dictionary.
     * @param { campaignId: String } campaignId to delete.
     * @param { triggerNames: [String] } array of trigger names that were previously mapped.
     */
    static func deleteCampaign(withId campaignId: String, andTriggerNames triggerNames: [String]) {
        for triggerName in triggerNames {
            if let setOfCampaignIdsByTriggerName = MessageMixerClient.mappedCampaigns[triggerName] {
                for campaign in setOfCampaignIdsByTriggerName {
                    if campaign.campaignData.campaignId == campaignId {
                        MessageMixerClient.mappedCampaigns[triggerName]?.remove(campaign)
                    }
                }
            }
        }
    }
}
