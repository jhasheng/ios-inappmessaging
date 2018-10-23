protocol CampaignStorable {
    // List of Item objects.
    static var list: Set<Campaign> { get set }
    
    // Add items into the list.
    static func addCampaign(_ campaign: Campaign)
}
