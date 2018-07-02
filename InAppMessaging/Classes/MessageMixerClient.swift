/**
 * Class to handle communication with InAppMessaging Mixer Server.
 */
class MessageMixerClient {
    
    private var messageMixerQueue = DispatchQueue(label: "MessageMixerQueue", attributes: .concurrent)
    private let commonUtility: CommonUtility

    init(commonUtility: CommonUtility = InjectionContainer.container.resolve(CommonUtility.self)!) {
        self.commonUtility = commonUtility
        
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
        guard let mixerServerUrl = commonUtility.retrieveFromMainBundle(forKey: "InAppMessagingMixerServerURL") as? String else {
            #if DEBUG
                print("Error retrieving InAppMessaging Mixer Server URL")
            #endif
            return
        }
        
        let response = commonUtility.callServer(withUrl: mixerServerUrl, withHTTPMethod: "POST")

        //(TODO: Daniel Tam) Handle response of message mixer when scope is clearer.
        print(response)
    }
}
