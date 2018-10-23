/**
 * Repository to store all the campaigns that are ready to be shown.
 */
struct ReadyCampaignRepository: RepositoryStorable {
    typealias Item = Campaign

    var list: [Campaign]
    
    mutating func addItem(item: Campaign) {
        list.append(item)
    }
}
