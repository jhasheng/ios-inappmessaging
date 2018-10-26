/**
 * Repository to store all the campaigns that were shown before.
 * TODO(Daniel Tam) At the moment, this is stored in-memory and not locally.
 */
struct DisplayedCampaignRepository: CampaignStorable {
    static var list: Set<Campaign> = []
    
    static func addCampaign(_ campaign: Campaign) {
        list.insert(campaign)
    }
    
    static func contains(_ campaign: Campaign) -> Bool {
        if list.contains(campaign) {
            return true
        }
        
        return false
    }
    
    static func clear() {
        list.removeAll()
    }
}
