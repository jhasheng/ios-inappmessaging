/**
 * Repository to hold the raw campaigns retreived from MessageMixerClient.
 */
struct CampaignRepository: CampaignStorable {
    static var list: Set<Campaign> = []
    
    static func addCampaign(_ campaign: Campaign) {
        CampaignRepository.list.insert(campaign)
    }
}
