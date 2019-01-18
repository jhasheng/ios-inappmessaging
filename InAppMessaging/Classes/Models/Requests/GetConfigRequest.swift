/**
 * Model of the request body for 'get-config'
 */
struct GetConfigRequest: Codable {
    let locale: String
    let appVersion: String
    let platform: String
    let appId: String
    let sdkVersion: String
}
