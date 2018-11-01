/**
 * Model of the request body for impression request.
 */
struct ImpressionRequest {
    let campaignId: String
    let isTest: Bool
    let subscriptionId: String
    let appVersion: String
    let sdkVersion: String
    let properties: [Attribute]
    let impressions: [Impression]
    let userIdentifiers: [UserIdentifier]
}
