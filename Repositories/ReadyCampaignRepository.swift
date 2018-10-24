/**
 * Repository to store all the campaigns that are ready to be shown.
 */
struct ReadyCampaignRepository: CampaignStorable {
    static var list: Set<Campaign> = []
    
    static func addCampaign(_ campaign: Campaign) {
        ReadyCampaignRepository.list.insert(campaign)
    }
}
    
