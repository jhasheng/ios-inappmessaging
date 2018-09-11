/**
 * Enum of all the actions the SDK can take
 * based on the permission response for a campaign.
 */
enum CampaignPermission: Int {
    case invalid = 0
    case show = 1
    case discard = 2
    case postpone = 3
}
