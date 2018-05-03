/**
 * Class to handle communication with InAppMessaging Mixer Server.
 */
class MessageMixerClient {
    
    // Variable to hold the number of seconds between each beacon ping to message mixer server.
    private let secondsBetweenInterval: Double
    private var timer: DispatchSourceTimer?
    private let commonUtility = InjectionContainer.container.resolve(CommonUtility.self)!

    init(secondsBetweenInterval: Double) {
        self.secondsBetweenInterval = secondsBetweenInterval
        self.setUpTimer()
    }
    
    /**
     * Function to retrieve Mixer Server URL then pings the server continously
     * based on the variable secondsBetweenInterval using Timer API.
     */
    fileprivate func setUpTimer() {
        guard let mixerServerUrl = commonUtility.retrieveFromMainBundle(forKey: "InAppMessagingMixerServerURL") as? String else {
            print("Error retrieving InAppMessaging Mixer Server URL")
            return
        }
        
        let queue = DispatchQueue(label: "InAppMessagingQueue", qos: .background, attributes: .concurrent)
        timer = DispatchSource.makeTimerSource(queue: queue)
        timer!.schedule(deadline: .now(), repeating: self.secondsBetweenInterval)
        timer!.setEventHandler {
            self.pingMixerServer(mixerServerUrl)
        }
        timer!.resume()
    }
    
    /**
     * The function called by the DispatchSourceTimer created in scheduledTimer().
     * This function handles the HTTP request and parsing the response body.
     * @param { messageMixerUrl: String } URL of InAppMessaging Mixer server.
     * (TODO: Daniel Tam) Parse for Message Mixer endpoint from Config response.
     */
    fileprivate func pingMixerServer(_ messageMixerUrl: String) {
        let response = commonUtility.callServer(withUrl: messageMixerUrl, withHTTPMethod: "POST")

        //(TODO: Daniel Tam) Handle response of message mixer when scope is clearer.
        print(response)
    }
}
