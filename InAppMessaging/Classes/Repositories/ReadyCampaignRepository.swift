/**
 * Repository to store all the campaigns that are ready to be shown.
 */
struct ReadyCampaignRepository {
    static var list: [Campaign] = []
    
    static func addCampaign(_ campaign: Campaign) {
        ReadyCampaignRepository.list.append(campaign)
    }
    
    static func getFirst() -> Campaign? {
        if let firstCampaign = ReadyCampaignRepository.list.first {
            return firstCampaign
        }
        
        return nil
    }
    
    static func removeFirst() {
        if !ReadyCampaignRepository.list.isEmpty {
            list.removeFirst()
        }
    }
    
    static func clear() {
        list.removeAll()
    }
    
    static func addAllCampaigns(_ campaigns: Set<Campaign>) {
        if !campaigns.isEmpty {
            for campaign in campaigns {
                self.list.append(campaign)
            }
        }
    }
}
