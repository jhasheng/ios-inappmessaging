/**
 * Class to handle communication with InAppMessaging Message Mixer Server.
 */
class MessageMixerClient: HttpRequestable {
    
    private let commonUtility: CommonUtility
    private let campaignHelper: CampaignHelper
    private let messageMixerQueue = DispatchQueue(label: "MessageMixerQueue", attributes: .concurrent)
    private var delay: Int = 0 // Milliseconds before pinging Message Mixer server.
    static var campaignDict = [String: [Campaign]]()
    static var listOfShownCampaigns = [String]()

    init(
        commonUtility: CommonUtility = InjectionContainer.container.resolve(CommonUtility.self)!,
        campaignHelper: CampaignHelper = InjectionContainer.container.resolve(CampaignHelper.self)!) {
        
            self.commonUtility = commonUtility
            self.campaignHelper = campaignHelper
    }
    
    internal func enable() {
        self.schedulePingToMixerServer(0) // First initial ping to Message Mixer server.
    }
    
    /**
     * Ping the Message Mixer server after delaying for X milliseconds.
     * @param { milliseconds: Int } - Milliseconds before executing the ping.
     */
    fileprivate func schedulePingToMixerServer(_ milliseconds: Int) {
        messageMixerQueue.asyncAfter(deadline: .now() + .milliseconds(milliseconds), execute: {
            self.pingMixerServer()
        })
    }
    
    /**
     * The function called by the DispatchSourceTimer created in scheduledTimer().
     * This function handles the HTTP request and parsing the response body.
     */
    fileprivate func pingMixerServer() {
        guard let mixerServerUrl = ConfigurationClient.endpoints?.ping else {
            #if DEBUG
                print("Error retrieving InAppMessaging Mixer Server URL")
            #endif
            return
        }
        
        guard let response = self.request(withUrl: mixerServerUrl, withHTTPMethod: .post) else {
            // Exponential backoff for pinging Message Mixer server.
            self.delay = (self.delay == 0) ? 1000 : self.delay * 2
            schedulePingToMixerServer(self.delay)
            return
        }
        
        var decodedResponse: CampaignResponse?
        
        do {
            let decoder = JSONDecoder()
            decodedResponse = try decoder.decode(CampaignResponse.self, from: response)
        } catch let error {
            #if DEBUG
                print("Failed to parse json:", error)
            #endif
        }
        
        if let campaignResponse = decodedResponse {
            MessageMixerClient.campaignDict = campaignHelper.mapCampaign(campaignList: campaignResponse.data)
            schedulePingToMixerServer(campaignResponse.nextPingMillis)
        }
    }
    
    internal func buildHttpBody() -> Data? {
        
        // Create the dictionary with the variables assigned above.
        let jsonDict: [String: Any] = [
            Keys.Request.SubscriptionID: Bundle.inAppSubscriptionId as Any,
            Keys.Request.UserID: IndentificationManager.userId
        ]
        
        // Return the serialized JSON object.
        return try? JSONSerialization.data(withJSONObject: jsonDict)
    }
}
