/**
 * Repository to hold the raw campaigns retreived from MessageMixerClient.
 */
struct CampaignRepository: RepositoryStorable {
    typealias Item = Campaign
    
    var list: [Campaign]
    
    mutating func addItem(item: Campaign) {
        list.append(item)
    }
    
}
