/**
 * Model of the request body for 'display-permission'.
 */
struct DisplayPermissionRequest: Encodable {
    let subscriptionId: String
    let campaignId: String
    let userIdentifiers: [UserIdentifier]
    let platform: String
    let appVersion: String
    let sdkVersion: String
    let locale: String
    let events: [Event]
}