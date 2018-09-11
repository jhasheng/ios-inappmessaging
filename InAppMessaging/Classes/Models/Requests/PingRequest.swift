/**
 * Model of the request body for ping request..
 */
struct PingRequest: Codable {
    let subscriptionId: String
    let userIdentifiers: [UserIdentifier]
    let appVersion: String
}
