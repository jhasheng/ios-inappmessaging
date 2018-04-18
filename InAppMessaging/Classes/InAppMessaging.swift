/**
 * Class that contains the public methods for host application to call.
 */
public class InAppMessaging {
    
    /**
     * Function to be called by host application to configure Rakuten InAppMessaging SDK.
     */
    public class func configure() {
        
        // Resolve container to a ConfigurationClient instance.
        let configurationClient = InjectionContainer.container.resolve(ConfigurationClient.self)!
        
        // (TODO: Daniel Tam) Implement logic for enabled/disabled SDK here.
        if configurationClient.checkConfigurationServer() {
            print("Enable SDK.")
        } else {
            print("Disable SDK.")
        }
    }
}

