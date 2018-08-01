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
     * @param { withUrl: String} the URL of the API to call.
     * @param { withHTTPMethod: String } the HTTP method used. E.G "POST" / "GET"
     * @returns { Optional [String: Any] } returns either nil or the response in a dictionary.
     */
    func request(withUrl: String, withHTTPMethod: HttpMethod) -> Data?
    
    /**
     * Build out the request body for talking to configuration server.
     * @returns { Optional Data } of serialized JSON object with the required fields.
     */
    func buildHttpBody() -> Data?
}

/**
 * Default implementation of HttpRequestable.
 */
extension HttpRequestable {
    func request(withUrl: String, withHTTPMethod: HttpMethod) -> Data? {
        var dataToReturn: Data?
        
        if let requestUrl = URL(string: withUrl) {
            
            // Add in the HTTP headers and body.
            var request = URLRequest(url: requestUrl)
            request.httpMethod = withHTTPMethod.stringValue
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = self.buildHttpBody()
            
            // Semaphore added for synchronous HTTP calls.
            let semaphore = DispatchSemaphore(value: 0)
            
            // Start HTTP call.
            URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
                
                if let err = error {
                    print("Error is: \(err)")
                    return
                }
                
                guard let data = data else {
                    print("Data returned is nil")
                    semaphore.signal()
                    return
                }
                
                print(CommonUtility.convertDataToDictionary(data)) //TEST.
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
