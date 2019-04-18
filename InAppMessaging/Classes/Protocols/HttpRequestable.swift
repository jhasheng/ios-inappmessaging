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
     * @param { url: String } the URL of the API to call.
     * @param { httpMethod: String } the HTTP method used. E.G "POST" / "GET"
     * @returns { Optional Data } returns either nil or the response in Data type.
     */
    func requestFromServer(withUrl url: String,
                 withHttpMethod httpMethod: HttpMethod,
                 withOptionalParams optionalParams: [String: Any],
                 withAdditionalHeaders addtionalHeaders: [Attribute]?,
                 withSemaphoreWait shouldWait: Bool) -> (data: Data?, response: HTTPURLResponse?)
    
    /**
     * Build out the request body for talking to configuration server.
     * @returns { Optional Data } of serialized JSON object with the required fields.
     */
    func buildHttpBody(withOptionalParams optionalParams: [String: Any]?) -> Data?
    
    /**
     * Append additional headers to the request body.
     * @param { header: [Attribute]? }
     */
    func appendHeaders(withHeaders headers: [Attribute]?, forRequest request: inout URLRequest)
}

/**
 * Default implementation of HttpRequestable.
 */
extension HttpRequestable {
    func requestFromServer(withUrl url: String,
        withHttpMethod httpMethod: HttpMethod,
        withOptionalParams optionalParams: [String: Any] = [:],
        withAdditionalHeaders addtionalHeaders: [Attribute]?,
        withSemaphoreWait shouldWait: Bool) -> (data: Data?, response: HTTPURLResponse?) {
        
            var dataToReturn: Data?
            var serverResponse: HTTPURLResponse?
        
            if let requestUrl = URL(string: url) {
                
                // Add in the HTTP headers and body.
                var request = URLRequest(url: requestUrl)
                request.httpMethod = httpMethod.stringValue
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = self.buildHttpBody(withOptionalParams: optionalParams)
                
                if let headers = addtionalHeaders {
                    self.appendHeaders(withHeaders: headers, forRequest: &request)
                }
                
                // Semaphore added for synchronous HTTP calls.
                let semaphore = DispatchSemaphore(value: 0)
                
                // Start HTTP call.
                URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
                    
                    if let err = error {
                        print("InAppMessaging: \(err)")
                        return
                    }
                    
                    guard let data = data,
                        let response = response as? HTTPURLResponse
                    else {
                        #if DEBUG
                            print("InAppMessaging: HTTP call failed.")
                        #endif
                        semaphore.signal()
                        return
                    }
                    
                    dataToReturn = data
                    serverResponse = response
                    
                    // Signal completion of HTTP request.
                    semaphore.signal()
                }).resume()
                
                // Pause execution until signal() is called
                // if the request requires the response to act on.
                if shouldWait {
                    semaphore.wait()
                }
            }
        
            return (dataToReturn, serverResponse)
    }
    
    func appendHeaders(withHeaders headers: [Attribute]?, forRequest request: inout URLRequest) {
        if let headers = headers {
            for header in headers {
                request.addValue(header.v, forHTTPHeaderField: header.k)
            }
        }
    }
}
