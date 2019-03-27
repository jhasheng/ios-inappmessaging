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
                return eventValue != eventValue
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
}









