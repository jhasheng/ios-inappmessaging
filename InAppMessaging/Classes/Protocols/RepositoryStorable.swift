protocol RepositoryStorable {
    // Generic type Item to store elements into a list of objects.
    associatedtype Item
    
    // List of Item objects.
    static var list: [Item] { get set }
    
    // Add items into the list.
    mutating func addItem(item: Item)
}
