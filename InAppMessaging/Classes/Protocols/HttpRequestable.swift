/**
 * Enum for HTTPRequestable protcol for http methods.
 */
enum HttpMethod: String {
    case post
    case get
    case delete
    case put
    
    var stringValue: String {
        switch self {
        case .post:
            return "POST"
        case .get:
            return "GET"
        case .delete:
            return "DELETE"
        case .put:
            return "PUT"
        }
    }
}

/**
 * Protocol that is conformed to when a class requires HTTP communication abilities.
 */
protocol HttpRequestable {
    
    /**
     * Generic method for calling an API.
     * @param { withUrl: String } the URL of the API to call.
     * @param { withHTTPMethod: String } the HTTP method used. E.G "POST" / "GET"
     * @returns { Optional [String: Any] } returns either nil or the response in a dictionary.
     */
    func request(withUrl url: String,
                 withHttpMethod httpMethod: HttpMethod,
                 withOptionalParams optionalParams: [String: Any]) -> Data?
    
    /**
     * Build out the request body for talking to configuration server.
     * @returns { Optional Data } of serialized JSON object with the required fields.
     */
    func buildHttpBody(withOptionalParams optionalParams: [String: Any]?) -> Data?
}

/**
 * Default implementation of HttpRequestable.
 */
extension HttpRequestable {
    func request(withUrl url: String,
                 withHttpMethod httpMethod: HttpMethod,
                 withOptionalParams optionalParams: [String: Any] = [:]) -> Data? {
        
        var dataToReturn: Data?
        
        if let requestUrl = URL(string: url) {
            
            // Add in the HTTP headers and body.
            var request = URLRequest(url: requestUrl)
            request.httpMethod = httpMethod.stringValue
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = self.buildHttpBody(withOptionalParams: optionalParams)
            
            // Semaphore added for synchronous HTTP calls.
            let semaphore = DispatchSemaphore(value: 0)
            
            // Start HTTP call.
            URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
                
                if let err = error {
                    print("InAppMessaging: \(err)")
                    return
                }
                
                guard let data = data else {
                    print("InAppMessaging: data returned is nil")
                    semaphore.signal()
                    return
                }
                
                dataToReturn = data
                
                // Signal completion of HTTP request.
                semaphore.signal()
            }).resume()
            
            // Pause execution until signal() is called
            semaphore.wait()
        }
        
        return dataToReturn
    }
}

/**
 * Request body for Message Mixer Client.
 */
extension HttpRequestable where Self: MessageMixerClient {
    internal func buildHttpBody(withOptionalParams optionalParams: [String: Any]?) -> Data? {
        
        var jsonDict = optionalParams ?? [:]
        
        // Create the dictionary with the variables assigned above.
        jsonDict = [
            Keys.Request.SubscriptionID: Bundle.inAppSubscriptionId as Any,
            Keys.Request.UserIdentifiers: IndentificationManager.userIdentifiers
        ]
        
        // Return the serialized JSON object.
        return try? JSONSerialization.data(withJSONObject: jsonDict)
    }
}

/**
 * Request body for Configuration client.
 */
extension HttpRequestable where Self: ConfigurationClient {
    internal func buildHttpBody(withOptionalParams optionalParams: [String: Any]?) -> Data? {
        
        var jsonDict = optionalParams ?? [:]
        
        // Create the dictionary with the variables assigned above.
        jsonDict = [
            Keys.Request.AppID: Bundle.applicationId as Any,
            Keys.Request.Platform: "iOS",
            Keys.Request.AppVersion: Bundle.appBuildVersion as Any,
            Keys.Request.SDKVersion: Bundle.inAppSdkVersion as Any,
            Keys.Request.Locale: Locale.formattedCode as Any
        ]
        
        // Return the serialized JSON object.
        return try? JSONSerialization.data(withJSONObject: jsonDict)
    }
}
