/**
 *  Class that provides common utility methods for RakutenInAppMessaging module.
 */
class CommonUtility {
    
//    /**
//     * Builds the request header for HTTP calls.
//     * @param { withURL: URL } contains the URL to call.
//     * @param { withHTTPMethod: String } the HTTP method used. E.G "POST" / "GET"
//     * @returns { URLRequest } URLRequest object with the specified HTTP method and added headers.
//     */
//    fileprivate func buildHTTPRequest(withURL: URL, HTTPMethod: String) -> URLRequest {
//        var request = URLRequest(url: withURL)
//        request.httpMethod = HTTPMethod
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        return request
//    }
//    
    /**
     * Convert data returned from callServer() to [String: Any]? type.
     */
    internal func convertDataToDictionary(_ data: Data) -> [String: Any]? {
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
    
    /**
     * Build out the request body for talking to configuration server.
     * @returns { Optional Data } of serialized JSON object with the required fields.
     */
//    fileprivate func buildHttpBody() -> Data? {
//
//        // Assign all the variables required in request body to configuration server.
//        guard let appId = self.retrieveFromMainBundle(forKey: "CFBundleIdentifier"),
//            let appVersion = self.retrieveFromMainBundle(forKey: "CFBundleVersion"),
//            let sdkVersion = self.retrieveFromMainBundle(forKey: Keys.Bundle.SDKVersion),
//            let subscriptionId = self.retrieveFromMainBundle(forKey: Keys.Bundle.SubscriptionID),
//            let locale = "\(Locale.current)".components(separatedBy: " ").first else {
//
//                return nil
//        }
//
//        // Create the dictionary with the variables assigned above.
//        let jsonDict: [String: Any] = [
//            Keys.Request.AppID: appId,
//            Keys.Request.Platform: "iOS",
//            Keys.Request.AppVersion: appVersion,
//            Keys.Request.SDKVersion: sdkVersion,
//            Keys.Request.Locale: locale,
//            Keys.Request.SubscriptionID: subscriptionId,
//            Keys.Request.UserID: IndentificationManager.userId
//        ]
//
//        // Return the serialized JSON object.
//        return try? JSONSerialization.data(withJSONObject: jsonDict)
//    }
    
    /**
     * Returns timestamp in milliseconds since epoch.
     * @returns { double } milliseconds since epoch.
     */
    internal func getTimeStamp() -> Double {
        return Date().timeIntervalSince1970
    }
}
