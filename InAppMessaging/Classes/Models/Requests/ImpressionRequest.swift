/**
 * Model of the request body for impression request.
 */
struct ImpressionRequest: Codable {
    let campaignId: String
    let subscriptionId: String
    let userIdentifiers: [UserIdentifier]
    let appVersion: String
}
