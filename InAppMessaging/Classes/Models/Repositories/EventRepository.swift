/**
 * Repository to store all the events that were logged from the host app.
 */
struct EventRepository: EventStorable {
    static var list: [Event] = []
    
    static func addEvent(_ event: Event) {
        EventRepository.list.append(event)
    }
}
