/**
 * Handle the request for custom event endpoint.
 */
struct EventClient: HttpRequestable {
    
    /**
     * Keys for the optionalParams dictionary.
     */
    let eventsKey = "events"
    
    /**
     * Reports the saved custom events to IAM's backend.
     * With a response code of 200, clear the saved events.
     */
    func reportEvents() {
        guard let eventEndpoint = ConfigurationClient.endpoints?.customEvent else {
            #if DEBUG
                print("InAppMessaging: Error retrieving InAppMessaging Events URL")
            #endif
            return
        }
        
        let optionalParams: [String : Any] = [
            eventsKey: EventLogger.eventLog
        ]
        
        // Send data back to events endpoint.
        let response = self.requestFromServer(
            withUrl: eventEndpoint,
            withHttpMethod: .post,
            withOptionalParams: optionalParams,
            withAdditionalHeaders: buildRequestHeader()).response
        
        // Clear custom event logs if event request was a 200.
        if let httpStatusCode = response?.statusCode {
            if httpStatusCode == 200 {
                EventLogger.clearLogs()
            }
        }
    }
    
    func buildHttpBody(withOptionalParams optionalParams: [String : Any]?) -> Data? {
        guard let params = optionalParams,
            let events = params[eventsKey] as? [Event]
        else {
            #if DEBUG
                print("InAppMessaging: Error building impressions request body.")
            #endif
            return nil
        }
        
        let eventsRequest = EventRequest(
            events: events
        )
        
        do {
            return try JSONEncoder().encode(eventsRequest)
        } catch {
            #if DEBUG
                print("InAppMessaging: Error encoding events request.")
            #endif
        }
        
        return nil
    }
    
    fileprivate func buildRequestHeader() -> [Attribute] {
        var additionalHeaders: [Attribute] = []
        
        // Retrieve sub ID and return in header of the request.
        if let subId = Bundle.inAppSubscriptionId {
            additionalHeaders.append(Attribute(withKeyName: Keys.Request.subscriptionHeader, withValue: subId))
        }
        
        return additionalHeaders
    }
}
