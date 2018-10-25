/**
 * Utility struct to provide methods for anything campaign related.
 */
struct CampaignParser {
    
    /**
     * Parses a campaign's trigger for it's event name
     */
    static func getCustomEventName(_ trigger: Trigger) -> String? {
        let attributes = trigger.attributes

        for attribute in attributes {
            if attribute.name == Keys.Event.eventName {
                return attribute.value
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
}
