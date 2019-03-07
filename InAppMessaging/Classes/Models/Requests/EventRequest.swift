/**
 * Model of the request body for Event request.
 */
struct EventRequest: Codable {
    let events: [Event]
}
