/**
 * Repository to store all the campaigns that are ready to be shown.
 */
struct ReadyCampaignRepository: RepositoryStorable {
    typealias Item = Campaign

     static var list: [Campaign] = []
    
    mutating func addItem(item: Campaign) {
        ReadyCampaignRepository.list.append(item)
    }
}
