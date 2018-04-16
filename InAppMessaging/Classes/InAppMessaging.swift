/**
 * Class that contains the public methods for host application to call.
 */

import Swinject

/**
 * Function to called by host application to initialize Rakuten InAppMessaging SDK.
 */
public func configure() {
    let configurationClient = ConfigurationClient(commonUtility: CommonUtility())
    let container = Container()
    container.register(name:ConfigurationClient.self, factory: { _ in CommonUtility()})
    container.register
    
    // (TODO: Daniel Tam) remove if statement later.
    if configurationClient.checkConfigurationServer() {
        print("Enable SDK.")
    } else {
        print("Disable SDK.")
    }
}
