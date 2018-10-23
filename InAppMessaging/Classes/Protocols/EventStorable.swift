protocol EventStorable {
    // List of Item objects.
    static var list: [Event] { get set }
    
    // Add items into the list.
    static func addEvent(_ event: Event)
}
