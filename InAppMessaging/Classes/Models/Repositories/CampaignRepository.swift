/**
 * Repository to hold the raw campaigns retreived from MessageMixerClient.
 */
struct CampaignRepository: CampaignStorable {
    static var list: Set<Campaign> = []
    
    mutating func addItem(item: Campaign) {
        CampaignRepository.list.insert(item)
    }
}
