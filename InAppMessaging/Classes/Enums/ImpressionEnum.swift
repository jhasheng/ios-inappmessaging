/**
 * Enum of impression events.
 */
enum ImpressionType: Int, Encodable {
    case invalid = 0
    case impression = 1
    case actionOneButton = 2
    case actionTwoButton = 3
    case exitButton = 4
}
