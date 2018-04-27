/**
 * Class to handle communication with InAppMessaging Mixer Server.
 */
class MessageMixerClient {
    
    // Variable to hold the number of seconds between each beacon ping to message mixer server.
    let secondsBetweenInterval: Double
    let commonUtility: CommonUtility
    
    init(secondsBetweenInterval: Double, commonUtility: CommonUtility) {
        self.secondsBetweenInterval = secondsBetweenInterval
        self.commonUtility = commonUtility
        self.scheduledTimer()
    }
    
    /**
     * Function to retrieve Mixer Server URL then pings the server continously
     * based on the variable secondsBetweenInterval using Timer API.
     */
    fileprivate func scheduledTimer() {
        guard let mixerServerUrl = commonUtility.retrieveFromMainBundle(forKey: "InAppMessagingMixerServerURL") as? String else {
            print("Error retrieving InAppMessaging Mixer Server URL")
            return
        }
        
        // Dispatch Timer in main thread asynchronously because Timer cannot run on background thread.
        DispatchQueue.main.async {
            Timer.scheduledTimer(
                timeInterval: self.secondsBetweenInterval,
                target: self,
                selector: #selector(self.pingMixerServer),
                userInfo: mixerServerUrl,
                repeats: true
            )
        }
    }
    
    /**
     * The function called by the Timer created in scheduledTimer().
     * This function handles the http request and parsing the response body.
     * @param { timer: Timer } contains the Message Mixer URL passed in through userInfo property.
     */
    @objc fileprivate func pingMixerServer(timer: Timer) {
        let messageMixerUrl = timer.userInfo as! String
        let response = commonUtility.callServer(withUrl: messageMixerUrl, withHTTPMethod: "POST")
        
        //(TODO: Daniel Tam) Handle response of message mixer when scope is clearer.
        print(response)
    }
}
