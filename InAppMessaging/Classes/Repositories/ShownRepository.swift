struct ShownRepository: CampaignStorable {
    static var list: Set<Campaign> = []
    
    static func addCampaign(_ campaign: Campaign) {
        list.insert(campaign)
    }
}
