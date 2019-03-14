/**
 * Repository to store all the events that were logged from the host app.
 */
struct EventRepository: EventStorable, AnalyticsBroadcaster {
    static var list: [Event] = []

    static func addEvent(_ event: Event) {
        // Appends to the list of events.
        self.list.append(event)
    }
    
    static func clear() {
        self.list.removeAll()
    }
}
