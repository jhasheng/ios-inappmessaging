/**
 * Utility struct to provide methods for anything campaign related.
 * Helps parse fore fields, map responses, and provide display logic.
 */
struct CampaignHelper {
    
    /**
     * Map campaign list returned by message mixer to a hashmap of trigger names to array of campaigns.
     * @param { campaignList: Set<Campaign> } list of campaign sent by Message Mixer server.
     * @returns { [Int: Set<Campaign>] } Hashmap of event type to list of campaigns.
     */
    static func mapCampaign(campaignList: Set<Campaign>) -> [Int: Set<Campaign>] {
        var campaignDict = [Int: Set<Campaign>]()
        
        for campaign in campaignList {
            for campaignTrigger in campaign.campaignData.triggers {
                if campaignDict[campaignTrigger.eventType] != nil {
                    campaignDict[campaignTrigger.eventType]?.insert(campaign)
                } else {
                    campaignDict[campaignTrigger.eventType] = [campaign]
                }
            }
        }
        
        return campaignDict
    }
    
    // Return a list of campaign data instead.
    
    /**
     * Fetches a campaign based on two conditions -- campaign has not been shown before
     * and the event type matches.
     * @param { eventType: Int } event type to fetch from campaign list.
     * @returns { CampaignData? } optional CampaignData that matches the two conditions.
     */
    static func fetchCampaigns(withEventType eventType: Int) -> [CampaignData] {
        
        var listOfMatchingCampaigns: [CampaignData] = []
        
        if let campaignList = MessageMixerClient.mappedCampaigns[eventType] {
            for campaign in campaignList {
                if !self.isCampaignShown(campaignId: campaign.campaignData.campaignId) {
                    listOfMatchingCampaigns.append(campaign.campaignData)
                }
            }
        }
        
        return listOfMatchingCampaigns
    }
    
//    /**
//     * Fetches a campaign based on two conditions -- campaign has not been shown before
//     * and the event type matches.
//     * @param { eventType: Int } event type to fetch from campaign list.
//     * @returns { CampaignData? } optional CampaignData that matches the two conditions.
//     */
//    static func fetchCampaign(withEventType eventType: Int) -> CampaignData? {
//        if let campaignList = MessageMixerClient.mappedCampaigns[eventType] {
//            for campaign in campaignList {
//                if !self.isCampaignShown(campaignId: campaign.campaignData.campaignId) {
//                    return campaign.campaignData
//                }
//            }
//        }
//
//        return nil
//    }
    
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
     * Parses through the dictionary of trigger event types to campaigns and delete the campaign from the whole dictionary.
     * @param { campaignId: String } campaignId to delete.
     * @param { triggers: [Int] } array of trigger event types that were previously mapped.
     */
    static func deleteCampaign(withId campaignId: String, andTriggerNames triggers: [Int]) {
        for eventType in triggers {
            if let setOfCampaignIdsByTriggerName = MessageMixerClient.mappedCampaigns[eventType] {
                for campaign in setOfCampaignIdsByTriggerName {
                    if campaign.campaignData.campaignId == campaignId {
                        MessageMixerClient.mappedCampaigns[eventType]?.remove(campaign)
                    }
                }
            }
        }
    }
}
