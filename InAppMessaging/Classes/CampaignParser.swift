/**
 * Class to help extract data from the Messager Mixer's response body.
 */
class CampaignParser {
    
    /**
     * Search through list of all campaigns' triggers to find the first matching campaign to return.
     * @param { trigger: String } The trigger name logged by the host app.
     * @param { campaignListOptional: [CampaignList]? } Optional array of the list of campaigns.
     * @returns { CampaignData? } Optional campaign with the matching trigger name.
     */
    internal func findMatchingTrigger(trigger: String, campaignListOptional: [CampaignList]?) -> CampaignData? {
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
}
