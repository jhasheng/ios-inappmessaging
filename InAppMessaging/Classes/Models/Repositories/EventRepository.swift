/**
 * Repository to store all the events that were logged from the host app.
 */
struct EventRepository: RepositoryStorable {
    typealias Item = Event

    var list: [Event]
    
    mutating func addItem(item: Event) {
        list.append(item)
    }
    
}
