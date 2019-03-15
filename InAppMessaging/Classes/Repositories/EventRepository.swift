/**
 * Repository to store all the events that were logged from the host app.
 */
struct EventRepository: EventStorable, AnalyticsBroadcaster {
    static var list: [Event] = []

    static func addEvent(_ event: Event) {
        // Appends to the list of events.
        self.list.append(event)
        
        // Broadcast event to RAT SDK.
        EventRepository().sendEventName("inappmessaging_events", ["event": event.dictionary])
    }
    
    static func clear() {
        self.list.removeAll()
    }
}
