/**
 * Class that contains the public methods for host application to call.
 * Entry point for host application to communicate with InAppMessaging.
 * Conforms to NSObject and exposed with objc tag to make it work with Obj-c projects.
 */
@objc public class InAppMessaging: NSObject {
    
    private let configurationClient: ConfigurationClient
    private let messageMixerClient: MessageMixerClient
    
    init(
        configurationClient: ConfigurationClient = InjectionContainer.container.resolve(ConfigurationClient.self)!,
        messageMixerClient: MessageMixerClient = InjectionContainer.container.resolve(MessageMixerClient.self)!) {
        
            self.configurationClient = configurationClient
            self.messageMixerClient = messageMixerClient
    }
    
    /**
     * Function to be called by host application to start a new thread that
     * configures Rakuten InAppMessaging SDK.
     */
    public class func configure() {
//        Thread.init(target: self, selector:#selector(initializeSdk), object: nil).start()
        DispatchQueue.global(qos: .background).async {
            InAppMessaging().initializeSdk()
        }
    }
    
    /**
     * Function to initialize InAppMessaging Module.
     */
    fileprivate func initializeSdk() {
        // Return and exit thread if SDK were to be disabled.
        if !self.configurationClient.isConfigEnabled() {
            return;
        }
        
        messageMixerClient.enable()
        
        // Start an instance of the MessageMixerClient which starts beacon pinging message mixer server.
//        InjectionContainer.container.resolve(MessageMixerClient.self)!
    }
    
    /**
     * Log the event name passed in and also pass the event name to the view controller to display a matching campaign.
     * @param { name: String } name of the event.
     */
    public class func logEvent(_ name: String) {
        DispatchQueue.global(qos: .background).async {
            EventLogger.logEvent(name)
        }
        
        Presenter().display(name)
    }
    
    /**
     * Register the ID of the user.
     * @param { idType: Identification } the type of ID. E.G RakutenID or EasyID.
     * @param { id: String } the string value of the ID.
     */
    public class func registerId(idType: Identification, id: String) {
        DispatchQueue.global(qos: .background).async {
            IndentificationManager.registerId(idType, id)
        }
    }
}
