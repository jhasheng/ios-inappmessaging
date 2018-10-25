struct ShownRepository: CampaignStorable {
    static var list: Set<Campaign> = []
    
    static func addCampaign(_ campaign: Campaign) {
        list.insert(campaign)
    }
    
    static func contains(_ campaign: Campaign) -> Bool {
        if list.contains(campaign) {
            return true
        }
        
        return false
    }
}
