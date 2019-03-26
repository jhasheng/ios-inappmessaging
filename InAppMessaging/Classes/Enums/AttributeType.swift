/**
 * Enum of value type for custom event attributes.
 */
enum AttributeType: Int, Codable {
    case invalid = 0
    case string = 1
    case integer = 2
    case double = 3
    case boolean = 4
    case timeInMilli = 5
}
