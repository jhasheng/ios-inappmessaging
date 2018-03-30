// Helper methods to provide common utlity methods for the module.

class CommonUtility {
    /**
     * Retrieves the value of a specified key from main bundle.
     * @param { forKey: String } key of the property to extract value from.
     * @returns { Optional String } value of the key property.
     */
    func retrieveFromMainBundle(forKey: String) -> String? {
        guard let valueOfPropertyToRetrieve = Bundle.main.infoDictionary?[forKey]  as? String else {
            #if DEBUG
                assertionFailure("Failed to retrieve '\(forKey)' from main bundle.")
            #endif
            return nil
        }
        
        return valueOfPropertyToRetrieve
    }
}
