/**
 * Class that contains the public methods for host application to call.
 */

import Swinject

public class InAppMessaging {
    
    /**
     * Function to called by host application to configure Rakuten InAppMessaging SDK.
     */
    public class func configure() {
        
        // Container of ConfigurationClient with added dependency.
        let configurationClientContainer = Container()
        configurationClientContainer.register(ConfigurationClient.self) { _ in
            ConfigurationClient(commonUtility: CommonUtility())
        }
        
        // Resolve container into a ConfigurationClient instance.
        let configurationClient = configurationClientContainer.resolve(ConfigurationClient.self)!
        
        // (TODO: Daniel Tam) remove if statement later.
        if configurationClient.checkConfigurationServer() {
            print("Enable SDK.")
        } else {
            print("Disable SDK.")
        }
    }
}

