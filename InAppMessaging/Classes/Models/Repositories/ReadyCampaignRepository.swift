/**
 * Repository to store all the campaigns that are ready to be shown.
 */
struct ReadyCampaignRepository: CampaignStorable {
     static var list: Set<Campaign> = []
    
    mutating func addItem(item: Campaign) {
        ReadyCampaignRepository.list.insert(item)
    }
}
