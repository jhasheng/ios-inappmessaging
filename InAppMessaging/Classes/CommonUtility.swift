/**
 *  Struct that provides common utility methods for RakutenInAppMessaging module.
 */
struct CommonUtility {
    
    /**
     * Convert Data type responses to [String: Any]? type.
     */
    static func convertDataToDictionary(_ data: Data) -> [String: Any]? {
        var dataToReturn: [String: Any]?
        
        do {
            guard let jsonData = try JSONSerialization
                .jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                    return nil
            }
            
            dataToReturn = jsonData
        } catch let error {
            print("Error converting data: \(error)")
            return nil
        }
        
        return dataToReturn
    }
}
