protocol CampaignStorable {
    // List of Item objects.
    static var list: Set<Campaign> { get set }
    
    // Add items into the list.
    mutating func addItem(item: Campaign)
}
