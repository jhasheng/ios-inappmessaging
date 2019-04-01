/**
 * Utility class to handle value comparison and
 * matching for the campaign reconciliation process.
 */
struct MatchingUtil {
    
    private static let TIME_IN_MILLIS_TOLERANCE = 1000
    
    static func compareValues(
        withTriggerAttributeValue triggerAttributeValue: String,
        withEventAttributeValue eventAttributeValue: String,
        andOperator operatorType: AttributeOperator) -> Bool {
        
        // Make both values to compare case-insensitive.
        let triggerValue = triggerAttributeValue.lowercased()
        let eventValue = eventAttributeValue.lowercased()
        
        switch operatorType {
            case .EQUALS:
                return eventValue == triggerValue
            case .IS_NOT_EQUAL:
                return eventValue != triggerValue
            case .IS_BLANK:
                return eventValue.isEmpty
            case .IS_NOT_BLANK:
                return !eventValue.isEmpty
            case .MATCHES_REGEX:
                return matches(for: triggerValue, in: eventValue)
            case .DOES_NOT_MATCH_REGEX:
                return matches(for: triggerValue, in: eventValue)
            case .INVALID,
                 .GREATER_THAN,
                 .LESS_THAN
                
                return false
        }
    }
    
    static func compareValues(
        withTriggerAttributeValue triggerAttributeValue: Int,
        withEventAttributeValue eventAttributeValue: Int,
        andOperator operatorType: AttributeOperator) -> Bool {
        
        switch operatorType {
            case .EQUALS:
                return eventAttributeValue == triggerAttributeValue
            case .IS_NOT_EQUAL:
                return eventAttributeValue != triggerAttributeValue
            case .GREATER_THAN:
                return eventAttributeValue > triggerAttributeValue
            case .LESS_THAN:
                return eventAttributeValue < triggerAttributeValue
            case .INVALID,.IS_BLANK,
                 .IS_NOT_BLANK,
                 .MATCHES_REGEX,
                 .DOES_NOT_MATCH_REGEX:
                
                return false
        }
    }
    
    static func compareValues(
        withTriggerAttributeValue triggerAttributeValue: Double,
        withEventAttributeValue eventAttributeValue: Double,
        andOperator operatorType: AttributeOperator) -> Bool {
        
        switch operatorType {
            case .EQUALS:
                return eventAttributeValue.isEqual(to: triggerAttributeValue)
            case .IS_NOT_EQUAL:
                return !eventAttributeValue.isEqual(to: triggerAttributeValue)
            case .GREATER_THAN:
                return triggerAttributeValue.isLess(than: eventAttributeValue)
            case .LESS_THAN:
                return eventAttributeValue.isLess(than: triggerAttributeValue)
            case .INVALID,
                 .IS_BLANK,
                 .IS_NOT_BLANK,
                 .MATCHES_REGEX,
                 .DOES_NOT_MATCH_REGEX:
                
                return false
        }
    }
    
    static func compareValues(
        withTriggerAttributeValue triggerAttributeValue: Bool,
        withEventAttributeValue eventAttributeValue: Bool,
        andOperator operatorType: AttributeOperator) -> Bool {
        
        switch operatorType {
            case .EQUALS:
                return eventAttributeValue == triggerAttributeValue
            case .IS_NOT_EQUAL:
                return eventAttributeValue != triggerAttributeValue
            case .INVALID,
                 .GREATER_THAN,
                 .LESS_THAN,
                 .IS_BLANK,
                 .IS_NOT_BLANK,
                 .MATCHES_REGEX,
                 .DOES_NOT_MATCH_REGEX:
                
                return false
        }
    }
    
    static func compareTimeValues(
        withTriggerAttributeValue triggerAttributeValue: Int,
        withEventAttributeValue eventAttributeValue: Int,
        andOperator operatorType: AttributeOperator) -> Bool {
        
        switch operatorType {
        
            case .EQUALS:
                return (eventAttributeValue - triggerAttributeValue).magnitude <= TIME_IN_MILLIS_TOLERANCE
            case .IS_NOT_EQUAL:
                return (eventAttributeValue - triggerAttributeValue).magnitude > TIME_IN_MILLIS_TOLERANCE
            case .GREATER_THAN:
                return (eventAttributeValue - triggerAttributeValue) > TIME_IN_MILLIS_TOLERANCE
            case .LESS_THAN:
                return (eventAttributeValue - triggerAttributeValue) < TIME_IN_MILLIS_TOLERANCE
            case .INVALID,
                 .IS_BLANK,
                 .IS_NOT_BLANK,
                 .MATCHES_REGEX,
                 .DOES_NOT_MATCH_REGEX:
                
                return false
            }
    }
    
    /**
     * Searches a string to see if it matches a regular expression or not.
     * @param { regex: String } the regular expression.
     * @param { text: String } the text to apply the regex to.
     * @returns { Bool } whether or not the string matches the regex.
     */
    fileprivate static func matches(for regex: String, in text: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = text as NSString
            let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
            
            return !results.isEmpty
        } catch let error {
            return false
        }
    }
}
