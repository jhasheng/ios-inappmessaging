/**
 * Repository to hold the raw campaigns retreived from MessageMixerClient.
 */
struct PingResponseRepository: CampaignStorable {
    static var list: Set<Campaign> = []
    static var currentPingInMillis: Int?
    
    static func addCampaign(_ campaign: Campaign) {
        PingResponseRepository.list.insert(campaign)
    }
    
    static func clear() {
        list.removeAll()
    }
}
