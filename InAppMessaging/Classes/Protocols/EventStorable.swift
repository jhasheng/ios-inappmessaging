protocol EventStorable {
    // List of Item objects.
    static var list: [Event] { get set }
    
    // Add items into the list.
    mutating func addItem(item: Event)
}
