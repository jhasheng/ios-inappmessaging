/**
 * Repository to store all the events that were logged from the host app.
 */
struct EventRepository: EventStorable {
    static var list: [Event] = []
    
    mutating func addItem(item: Event) {
        EventRepository.list.append(item)
    }
}
