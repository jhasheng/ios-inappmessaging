/**
 * Model of the request body for impression request.
 */
struct ImpressionRequest {
    let campaignId: String
    let hostAppData: [Attribute]
    let impressions: [ImpressionType]
    let userIdentifiers: [UserIdentifier]
}
