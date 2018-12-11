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
        if InAppMessaging.isEnabled {
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
     * Register the ID of the user.
     * @param { idType: Identification } the type of ID. E.G RakutenID or UserID.
     * @param { id: String } the string value of the ID.
     */
    @objc public class func registerId(idType: Identification, id: String) {
        DispatchQueue.global(qos: .background).async {
            IndentificationManager.registerId(idType, id)
            
            // Everytime a new ID is registered, send a ping request.
            if InAppMessaging.isEnabled {
                MessageMixerClient().ping()
            }
        }
    }
    
    /**
     * Register the access token retrieved from RAuthentication.
     * The token will be in RAuthenticationAccount.token.accessToken.
     * @param { token: String } value of the access token being passed in.
     */
    @objc public class func registerAccessToken(_ token: String) {
        
        let test = InAppMessagingPreferenceBuilder()
            .setUserId("dsf")
            .setAccessToken("sdfsfsf")
            .setRakutenId("sdfsf")
            .build()
        
        DispatchQueue.global(qos: .background).async {
            IndentificationManager.registerAccessToken(token)
        }
    }
}
