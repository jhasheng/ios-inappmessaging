/**
 * Repository to store all the campaigns that were shown before.
 */
struct DisplayedCampaignRepository {
    
    // Mapping of the campaigns that are shown before.
    // The mapping maps campaign id to a counter of how many times
    // the campaign has been shown.
    static var map: [String: Int] = [:]
    
    static func addCampaign(_ campaign: Campaign) {
        
        let campaignId = campaign.campaignData.campaignId
        
        // Increment count by 1 if exists, else set campaign count to 1
        if map.keys.contains(campaignId) {
            map[campaignId]! += 1
        } else {
            map[campaignId] = 1
        }
    }
    
    static func getDisplayCount(forCampaign campaign: Campaign) -> Int {
        return map[campaign.campaignData.campaignId] ?? 0
    }
}
