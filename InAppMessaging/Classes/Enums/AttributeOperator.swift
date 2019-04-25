/**
 * Enum of operators for matching.
 */
enum AttributeOperator: Int, Codable {
    case INVALID = 0
    case EQUALS = 1
    case IS_NOT_EQUAL = 2
    case GREATER_THAN = 3
    case LESS_THAN = 4
    case IS_BLANK = 5
    case IS_NOT_BLANK = 6
    case MATCHES_REGEX = 7
    case DOES_NOT_MATCH_REGEX = 8
}
