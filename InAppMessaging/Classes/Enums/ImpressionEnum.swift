/**
 * Enum of impression events.
 */
enum ImpressionType: Int, Encodable {
    case invalid = 0
    case impression = 1
    case exitButton = 2
    case actionOneButton = 3
    case actionTwoButton = 4
}
