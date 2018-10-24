struct EventParser {
    
    static func getCustomEventName(_ event: Event) -> String? {
        guard let attributes = event.customAttributes else {
            return nil
        }
        
        for attribute in attributes {
//            if attribute
        }
        
        return nil
    }
}
