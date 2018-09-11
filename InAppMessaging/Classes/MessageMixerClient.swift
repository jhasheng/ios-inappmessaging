/**
 * Class to handle communication with InAppMessaging Message Mixer Server.
 */
class MessageMixerClient: HttpRequestable {
    
    private static var delay: Int = 0 // Milliseconds before pinging Message Mixer server.
    static var campaignDict = [String: [Campaign]]()
    static var listOfShownCampaigns = [String]()
    
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
        
        var decodedResponse: CampaignResponse?
        
        do {
            let decoder = JSONDecoder()
            decodedResponse = try decoder.decode(CampaignResponse.self, from: response)
        } catch let error {
            #if DEBUG
                print("InAppMessaging: Failed to parse json:", error)
            #endif
        }
        
        if let campaignResponse = decodedResponse {
            MessageMixerClient.campaignDict = CampaignHelper.mapCampaign(campaignList: campaignResponse.data)
            WorkScheduler.scheduleTask(campaignResponse.nextPingMillis, closure: self.pingMixerServer)
        }
    }
    
    /**
     * Request body for Message Mixer Client to hit ping endpoint.
     */
    internal func buildHttpBody(withOptionalParams optionalParams: [String: Any]?) -> Data? {
        
        guard let subscriptionId = Bundle.inAppSubscriptionId else {
            return nil
        }
        
        let pingRequest = PingRequest.init(
            subscriptionId: subscriptionId,
            userIdentifiers: IndentificationManager.userIdentifiers)
        
        do {
            return try JSONEncoder().encode(pingRequest)
        } catch {
            print("InAppMessaging: failed creating a request body.")
        }
        
        return nil
    }
}
