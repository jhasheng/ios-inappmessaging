/**
 * Repository to store all the events that were logged from the host app.
 */
struct EventRepository: EventStorable {
    static var list: [Event] = []

    static func addEvent(_ event: Event) {
        // Appends to the list of events.
        list.append(event)
    }
    
    static func clear() {
        list.removeAll()
    }
}
