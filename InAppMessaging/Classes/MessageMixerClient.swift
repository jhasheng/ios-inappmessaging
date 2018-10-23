/**
 * Class to handle communication with InAppMessaging Message Mixer Server.
 */
class MessageMixerClient: HttpRequestable {
    
    private static var delay: Int = 0 // Milliseconds before pinging Message Mixer server.
    private static var isFirstPing = true;
    static var mappedCampaigns = [Int: Set<Campaign>]()
    static var listOfShownCampaigns = Set<String>()
    
    /**
     * Starts the first ping to Message Mixer server.
     */
    internal func enable() {
        WorkScheduler.scheduleTask(0, closure: self.pingMixerServer)
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
        
        guard let response = self.requestFromServer(withUrl: mixerServerUrl, withHttpMethod: .post) else {
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
        
        if let campaignResponse = decodedResponse {
            MessageMixerClient.mappedCampaigns = CampaignHelper.mapCampaign(campaignList: campaignResponse.data)
            CampaignRepository.list = campaignResponse.data
            WorkScheduler.scheduleTask(campaignResponse.nextPingMillis, closure: self.pingMixerServer)
        }
        
        // After the first ping to message mixer, log the AppStartEvent.
        // This is to handle the async nature of both the ping and displayPermissions endpoint.
        if MessageMixerClient.isFirstPing {
            // TODO(Daniel Tam) Clarify if custom attributes should be defaulted to nil or not for app start event.
            InAppMessaging.logEvent(AppStartEvent(withCustomAttributes: nil))
            MessageMixerClient.isFirstPing = false;
        }
    }
    
    /**
     * Request body for Message Mixer Client to hit ping endpoint.
     * @param { optionalParams: [String: Any]? } additional params to be added to the request body.
     * @returns { Data? } optional serialized data for the request body.
     */
    internal func buildHttpBody(withOptionalParams optionalParams: [String: Any]?) -> Data? {
        
        guard let subscriptionId = Bundle.inAppSubscriptionId,
            let appVersion = Bundle.appBuildVersion
        else {
            #if DEBUG
                assertionFailure("InAppMessaging: Make sure there is a valid '\(Keys.Bundle.SubscriptionID)' key in your info.plist.")
            #endif
            return nil
        }
        
        let pingRequest = PingRequest.init(
            subscriptionId: subscriptionId,
            userIdentifiers: IndentificationManager.userIdentifiers,
            appVersion: appVersion
        )
        
        do {
            return try JSONEncoder().encode(pingRequest)
        } catch {
            print("InAppMessaging: failed creating a request body.")
        }
        
        return nil
    }
}
