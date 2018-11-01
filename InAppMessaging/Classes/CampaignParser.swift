/**
 * Utility struct to provide methods for anything campaign related.
 */
struct CampaignParser {
    
    /**
     * Parses a campaign's trigger for it's event name.
     * @param { trigger: Trigger } the trigger to parse.
     * @returns { String? } the eventName of the trigger or nil.
     */
    static func getCustomEventName(_ trigger: Trigger) -> String? {
        let attributes = trigger.attributes

        for attribute in attributes {
            if attribute.k == Keys.Event.eventName {
                return attribute.v
            }
        }

        return nil
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
     * Method to parse through each campaign and separate test campaigns from non-tests campaigns.
     * @param { campaigns: Set<Campaign> } the set of campaigns to parse through.
     * @returns { (testCampaigns: Set<Campaign>, nonTestCampaigns: Set<Campaign>) } set of test and non-test campaigns.
     */
    static func splitCampaigns(campaigns: Set<Campaign>) -> (testCampaigns: Set<Campaign>, nonTestCampaigns: Set<Campaign>) {
        var testCampaigns: Set<Campaign> = []
        var nonTestCampaigns: Set<Campaign> = []
        
        for campaign in campaigns {
            if(campaign.campaignData.isTest) {
                testCampaigns.insert(campaign)
            } else {
                nonTestCampaigns.insert(campaign)
            }
        }
        
        return (testCampaigns, nonTestCampaigns)
    }
}
