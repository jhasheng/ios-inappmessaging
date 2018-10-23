/**
 * Repository to hold the raw campaigns retreived from MessageMixerClient.
 */
struct CampaignRepository: RepositoryStorable {
    typealias Item = Campaign
    
    static var list: [Campaign] = []
    
    mutating func addItem(item: Campaign) {
        CampaignRepository.list.append(item)
    }
}
