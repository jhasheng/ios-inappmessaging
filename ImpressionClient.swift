/**
 * Handles hitting the impression endpoint.
 */
struct ImpressionClient: HttpRequestable {
    
    static func pingImpression(_ impressions: [Impression]) {
        
    }
    
    /**
     * Build the request body for hitting the impression endpoint.
     */
    func buildHttpBody(withOptionalParams optionalParams: [String : Any]?) -> Data? {
        return nil
    }
    
    
}
