/**
 * Class that contains the public methods for host application to call.
 * Entry point for host application to communicate with InAppMessaging.
 */
public class InAppMessaging {
    
    /**
     * Function to be called by host application to start a new thread that
     * configures Rakuten InAppMessaging SDK.
     */
    public class func configure() {
        Thread.init(target: self, selector:#selector(initializeSdk), object: nil).start()
    }
    
    /**
     * Function to initialize InAppMessaging Module.
     * Wrapped with @objc so that it can be used as a Selector.
     */
    @objc static func initializeSdk() {
        // Resolve container to a ConfigurationClient instance.
        let configurationClient = InjectionContainer.container.resolve(ConfigurationClient.self)!
        
        // Return and exit thread if SDK were to be disabled.
        if !configurationClient.checkConfigurationServer() {
            return;
        }
        
        // (TODO: Daniel Tam) Implement logic for enabled SDK here.
        // Enqueue task into this GCD dispatch queue.
        let concurrentQueue = DispatchQueue(label: "InAppMessagingQueue", attributes: .concurrent)
    }
}
