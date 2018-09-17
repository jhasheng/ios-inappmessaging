/**
 * Enum of all the actions the SDK can take
 * based on the permission response for a campaign.
 * More information here: https://confluence.rakuten-it.com/confluence/pages/viewpage.action?pageId=1656430178
 */
enum PermissionAction: Int {
    case invalid = 0
    case show = 1
    case discard = 2
    case postpone = 3
}
