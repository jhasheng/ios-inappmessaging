/**
 * Protocol for repositories that stores Campaign types.
 */
protocol CampaignStorable {
    // List of Campaign objects.
    static var list: Set<Campaign> { get set }
    
    // Add campaigns into the list.
    static func addCampaign(_ campaign: Campaign)
    
    // Clear the list.
    static func clear()
}
