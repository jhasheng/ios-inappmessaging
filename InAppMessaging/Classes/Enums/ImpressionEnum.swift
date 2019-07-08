/**
 * Enum of impression events.
 */
enum ImpressionType: Int, Encodable {
    case INVALID = 0
    case IMPRESSION = 1
    case ACTION_ONE = 2
    case ACTION_TWO = 3
    case EXIT = 4
    case CLICK_CONTENT = 5
    case OPT_OUT = 6
    
    var description: String {
        get {
            switch self {
            case .INVALID:
                return "INVALID"
            case .IMPRESSION:
                return "IMPRESSION"
            case .ACTION_ONE:
                return "ACTION_ONE"
            case .ACTION_TWO:
                return "ACTION_TWO"
            case .EXIT:
                return "EXIT"
            case .CLICK_CONTENT:
                return "CLICK_CONTENT"
            case .OPT_OUT:
                return "OPT_OUT"
            }
        }
    }
}
