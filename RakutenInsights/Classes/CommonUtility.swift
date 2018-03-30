/**
 *  Class that provides common utility methods for RakutenInsights module.
 */

class CommonUtility {
    
    /**
     * Retrieves the value of a specified key from main bundle.
     * @param { forKey: String } key of the property to extract value from.
     * @returns { Optional String } value of the key property.
     */
    internal func retrieveFromMainBundle(forKey: String) -> String? {
        guard let valueOfPropertyToRetrieve = Bundle.main.infoDictionary?[forKey]  as? String else {
            #if DEBUG
                print("RakutenInsights: Failed to retrieve '\(forKey)' from main bundle.")
            #endif
            return nil
        }
        
        return valueOfPropertyToRetrieve
    }
}
