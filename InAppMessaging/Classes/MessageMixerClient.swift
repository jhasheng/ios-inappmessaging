/**
 * Class to handle communication with InAppMessaging Message Mixer Server.
 */
class MessageMixerClient: HttpRequestable, TaskSchedulable {
    
    static var workItemReference: DispatchWorkItem?
    private static var delay: Int = 0 // Milliseconds before pinging Message Mixer server.
    private static var isFirstPing = true;
    
    /**
     * Starts the first ping to Message Mixer server.
     */
    internal func ping() {
        self.pingMixerServer()
    }
    
    /**
     * The function called by the DispatchSourceTimer created in scheduledTimer().
     * This function handles the HTTP request and parsing the response body.
     */
    fileprivate func pingMixerServer() {
        guard let mixerServerUrl = ConfigurationClient.endpoints?.ping else {
            #if DEBUG
                print("InAppMessaging: Error retrieving InAppMessaging Mixer Server URL")
            #endif
            return
        }
        
        guard let response = self.requestFromServer(
            withUrl: mixerServerUrl,
            withHttpMethod: .post,
            withAdditionalHeaders: buildRequestHeader()) else {
                
                // Exponential backoff for pinging Message Mixer server.
                MessageMixerClient.delay = (MessageMixerClient.delay == 0) ? 10000 : MessageMixerClient.delay * 2
                WorkScheduler.scheduleTask(MessageMixerClient.delay, closure: self.pingMixerServer)
                return
        }
        
        var decodedResponse: PingResponse?
        
        do {
            let decoder = JSONDecoder()
            decodedResponse = try decoder.decode(PingResponse.self, from: response)
        } catch let error {
            #if DEBUG
                print("InAppMessaging: Failed to parse json:", error)
            #endif
        }
        
        // If new ping response is decoded properly.
        if let campaignResponse = decodedResponse {
            CommonUtility.lock(
                objects: [
                    PingResponseRepository.list as AnyObject,
                    EventRepository.list as AnyObject,
                    ReadyCampaignRepository.list as AnyObject],
                pingResponse: campaignResponse,
                closure: self.handleNewPingResponse)
            
            let workItem = DispatchWorkItem { self.pingMixerServer() }
            scheduleWorkItem(campaignResponse.nextPingMillis, task: workItem)
        }
        
        // After the first ping to message mixer, log the AppStartEvent.
        // This is to handle the async nature of both the ping and displayPermissions endpoint.
        if MessageMixerClient.isFirstPing {
            InAppMessaging.logEvent(AppStartEvent(withCustomAttributes: nil))
            MessageMixerClient.isFirstPing = false;
        }
    }
    
    /**
     * Logic to handle new ping responses. It will clear the existing repositories and
     * insert the new campaigns. On every ping that isn't the first, start the
     * reconciliation process.
     * @param { pingResponse: PingResponse } the new ping response.
     */
    private func handleNewPingResponse(pingResponse: PingResponse) {
        // Renew repository with new response.
        PingResponseRepository.list = pingResponse.data
        PingResponseRepository.currentPingMillis = pingResponse.currentPingMillis
        ReadyCampaignRepository.clear()
        
        // Start campaign reconciliation process.
        if !MessageMixerClient.isFirstPing {
            CampaignReconciliation.reconciliate()
        }
    }
    
    /**
     * Request body for Message Mixer Client to hit ping endpoint.
     * @param { optionalParams: [String: Any]? } additional params to be added to the request body.
     * @returns { Data? } optional serialized data for the request body.
     */
    internal func buildHttpBody(withOptionalParams optionalParams: [String: Any]?) -> Data? {
        
        guard let subscriptionId = Bundle.inAppSubscriptionId,
            let appVersion = Bundle.appVersionString
        else {
            #if DEBUG
                assertionFailure("InAppMessaging: Make sure there is a valid '\(Keys.Bundle.SubscriptionID)' key in your info.plist.")
            #endif
            return nil
        }
        
        let pingRequest = PingRequest.init(
            subscriptionId: subscriptionId,
            userIdentifiers: IAMPreferenceRepository.getUserIdentifiers(),
            appVersion: appVersion
        )
        
        do {
            return try JSONEncoder().encode(pingRequest)
        } catch {
            print("InAppMessaging: failed creating a request body.")
        }
        
        return nil
    }
    
    fileprivate func buildRequestHeader() -> [Attribute] {
        var additionalHeaders: [Attribute] = []
        
        // Retrieve sub ID and return in header of the request.
        if let subId = Bundle.inAppSubscriptionId {
            additionalHeaders.append(Attribute(withKeyName: Keys.Request.subscriptionHeader, withValue: subId))
        }
        
        // Retrieve device ID and return in header of the request.
        if let deviceId = UIDevice.current.identifierForVendor?.uuidString {
            additionalHeaders.append(Attribute(withKeyName: Keys.Request.deviceID, withValue: deviceId))
        }
        
        // Retrieve access token and return in the header of the request.
        if let accessToken = IAMPreferenceRepository.getAccessToken() {
            additionalHeaders.append(Attribute(withKeyName: Keys.Request.authorization, withValue: "OAuth2 \(accessToken)"))
        }
        
        return additionalHeaders
    }
}
