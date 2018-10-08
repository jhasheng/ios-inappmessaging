/**
 * Enum of the event types from ping response.
 * More information here: https://confluence.rakuten-it.com/confluence/pages/viewpage.action?pageId=1606670604
 */
enum EventType: Int, Codable {
    case invalid = 0
    case appStart = 1
    case loginSuccessful = 2
    case purchaseSuccessful = 3
    case custom = 4
}