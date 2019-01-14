/**
 * Class that contains the public methods for host application to call.
 * Entry point for host application to communicate with InAppMessaging.
 * Conforms to NSObject and exposed with objc tag to make it work with Obj-c projects.
 */
@objc public class InAppMessaging: NSObject {
    
    private let configurationClient: ConfigurationClient
    private let messageMixerClient: MessageMixerClient
    private static var isEnabled = false
    
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
    @objc public class func configure() {
        if !InAppMessaging.isEnabled {
            DispatchQueue.global(qos: .background).async {
                InAppMessaging().initializeSdk()
            }
        }
    }
    
    /**
     * Function to initialize InAppMessaging Module.
     */
    internal func initializeSdk() {
        // Return and exit thread if SDK were to be disabled.
        InAppMessaging.isEnabled = self.configurationClient.isConfigEnabled()
        if !InAppMessaging.isEnabled {
            return
        }
        
        // Enable MessageMixerClient which starts beacon pinging message mixer server.
        messageMixerClient.ping()
    }
    
    /**
     * Log the event name passed in and also pass the event name to the view controller to display a matching campaign.
     * @param { event: Event } Event object to log.
     */
    @objc public class func logEvent(_ event: Event) {
        if InAppMessaging.isEnabled {
            DispatchQueue.global(qos: .background).async {
                EventRepository.addEvent(event)
                
                CommonUtility.lock(
                    objects: [
                        CampaignRepository.list as AnyObject,
                        EventRepository.list as AnyObject,
                        ReadyCampaignRepository.list as AnyObject],
                    closure: CampaignReconciliation.reconciliate)
                
                InAppMessagingViewController.display()
            }
        }
    }
    
    /**
     * Register user preference to the IAM SDK.
     * @param { preference: IAMPreference } preferences of the user.
     */
    @objc public class func registerPreference(_ preference: IAMPreference) {
        DispatchQueue.global(qos: .background).async {
            IAMPreferenceRepository.setPreference(with: preference)

            // Everytime a new ID is registered, send a ping request.
            if InAppMessaging.isEnabled {
//                MessageMixerClient().ping()
                InAppMessagingViewController.display()
            }
        }
    }
}
