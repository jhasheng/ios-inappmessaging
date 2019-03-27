/**
 * Enum of value type for custom event attributes.
 */
enum AttributeType: Int, Codable {
    case INVALID = 0
    case STRING = 1
    case INTEGER = 2
    case DOUBLE = 3
    case BOOLEAN = 4
    case TIME_IN_MILLI = 5
}
