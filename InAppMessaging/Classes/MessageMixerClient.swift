/**
 * Class to handle communication with InAppMessaging Message Mixer Server.
 */
class MessageMixerClient {
    
    static let sharedInstance = MessageMixerClient()
    private let commonUtility: CommonUtility
    private let campaignParser: CampaignParser
    private let messageMixerQueue = DispatchQueue(label: "MessageMixerQueue", attributes: .concurrent)
    private var delay: Int = 0 // Milliseconds before pinging Message Mixer server.
    var campaign: [CampaignList]? // List of all campaigns returned by Message Mixer server.

    init(
        commonUtility: CommonUtility = InjectionContainer.container.resolve(CommonUtility.self)!,
        campaignParser: CampaignParser = InjectionContainer.container.resolve(CampaignParser.self)!) {
        
            self.commonUtility = commonUtility
            self.campaignParser = campaignParser
        
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
     * (TODO: Daniel Tam) Parse for Message Mixer endpoint from Config response.
     */
    fileprivate func pingMixerServer() {
        guard let mixerServerUrl = commonUtility.retrieveFromMainBundle(forKey: Keys.URL.MixerServerURL) as? String else {
            #if DEBUG
                print("Error retrieving InAppMessaging Mixer Server URL")
            #endif
            return
        }
        
        guard let response = commonUtility.callServer(withUrl: mixerServerUrl, withHTTPMethod: "POST") else {
            // Exponential backoff for pinging Message Mixer server.
            self.delay = (self.delay == 0) ? 1000 : self.delay * 2
            schedulePingToMixerServer(self.delay)
            return
        }
        
        //(TODO: Daniel Tam) Handle response of message mixer when scope is clearer.
        do {
            let decoder = JSONDecoder()
            MessageMixerClient.sharedInstance.campaign = try decoder.decode(CampaignResponse.self, from: response).data
            
            campaignParser.findMatchingTrigger(trigger: "purchase_unsuccessful", campaignListOptional: MessageMixerClient.sharedInstance.campaign)
        } catch let error {
            print("Failed to parse json:", error)
        }

    }
}
