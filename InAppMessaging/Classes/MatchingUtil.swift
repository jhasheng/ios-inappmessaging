struct MatchingUtil {
    
    static func compareValues(
        withTriggerAttributeValue triggerAttributeValue: String,
        withEventAttributeValue eventAttributeValue: String,
        andOperator operatorType: AttributeOperator) -> Bool {
        
        // Make both values to compare case-insensitive.
        let triggerValue = triggerAttributeValue.lowercased()
        let eventValue = eventAttributeValue.lowercased()
        
        switch operatorType {
            case .EQUALS:
                return triggerValue == eventValue
            case .IS_NOT_EQUAL:
                return triggerValue != eventValue
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
    
//    static func compareValues(
//        withTriggerAttributeValue triggerAttributeValue: Int,
//        withEventAttributeValue eventAttributeValue: Int,
//        andOperator operatorType: AttributeOperator) -> Bool {
//        
//        // Make both values to compare case-insensitive.
//        let triggerValue = triggerAttributeValue.lowercased()
//        let eventValue = eventAttributeValue.lowercased()
//        
//        switch operatorType {
//        case .EQUALS:
//            return triggerValue == eventValue
//        case .IS_NOT_EQUAL:
//            return triggerValue != eventValue
//        case .INVALID,
//             .GREATER_THAN,
//             .LESS_THAN,
//             .IS_BLANK,
//             .IS_NOT_BLANK,
//             .MATCHES_REGEX,
//             .DOES_NOT_MATCH_REGEX:
//            
//            return false
//        }
//    }
//    
}
