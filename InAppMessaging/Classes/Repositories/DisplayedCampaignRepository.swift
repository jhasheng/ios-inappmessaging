/**
 * Repository to store all the campaigns that were shown before.
 */
struct DisplayedCampaignRepository {
    
    // Mapping of the campaigns that are shown before.
    // The mapping maps campaign id to a counter of how many times
    // the campaign has been shown.
    static var map: [String: Int] = [:]
    
    /**
     * Append a campaign to the mapping.
     * If the campaign exists, increase counter by 1.
     * If it does not exist, set counter to 1.
     * @param { campaign: Campaign } campaign to add in the mapping.
     */
    static func addCampaign(_ campaign: Campaign) {
        
        let campaignId = campaign.campaignData.campaignId
        
        // Increment counter by 1 if exists, else set campaign count to 1
        if map.keys.contains(campaignId) {
            map[campaignId]! += 1
        } else {
            map[campaignId] = 1
        }
    }
    
    /**
     * Fetches the impression count for a specific campaign
     * @param { campaign: Campaign } campaign to fetch impression count for.
     * @returns { Int } number of times the campaign has been shown.
     */
    static func getDisplayCount(forCampaign campaign: Campaign) -> Int {
        return map[campaign.campaignData.campaignId] ?? 0
    }
}
