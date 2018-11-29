/**
 * Repository to store all the campaigns that were shown before.
 * TODO(Daniel Tam) At the moment, this is stored in-memory and not locally.
 */
//struct DisplayedCampaignRepository: CampaignStorable {
//    static var list: Set<Campaign> = []
//
//    static func addCampaign(_ campaign: Campaign) {
//        list.insert(campaign)
//    }
//
//    static func contains(_ campaign: Campaign) -> Bool {
//        if list.contains(campaign) {
//            return true
//        }
//
//        return false
//    }
//
//    static func clear() {
//        list.removeAll()
//    }
//}

struct DisplayedCampaignRepository {
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
