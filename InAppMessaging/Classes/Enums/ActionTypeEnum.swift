/**
 * Enum of all actions InAppMessaging supports.
 */
enum ActionType: Int, Decodable {
    case invalid = 0
    case redirect = 1
    case deeplink = 2
    case close = 3
}
