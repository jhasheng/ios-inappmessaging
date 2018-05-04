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
        self.startTimer()
    }
    
    /**
     * Function to retrieve Mixer Server URL then pings the server continously
     * based on the variable secondsBetweenInterval using DispatchSourceTimer API.
     */
    fileprivate func startTimer() {
        if self.secondsBetweenInterval > 0 {
            let queue = DispatchQueue(label: "InAppMessagingQueue", qos: .background, attributes: .concurrent)
            timer = DispatchSource.makeTimerSource(queue: queue)
            timer!.schedule(deadline: .now(), repeating: self.secondsBetweenInterval)
            timer!.setEventHandler {
                self.pingMixerServer()
            }
            timer!.resume()
        }
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
