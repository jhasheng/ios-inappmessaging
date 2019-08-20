/**
 * Repository to store all the campaigns that was opted out by the user.
 */
struct OptedOutRepository {
    static var list: Set<CampaignData> = []
    
    static func addCampaign(_ campaign: CampaignData) {
        list.insert(campaign)
    }
    
    static func contains(_ campaign: CampaignData) -> Bool {
        return list.contains(campaign)
    }
}
