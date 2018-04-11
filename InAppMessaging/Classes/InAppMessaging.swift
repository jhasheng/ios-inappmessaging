/**
 * Class that contains the public methods for host application to call.
 */

/**
 * Function to called by host application to initialize Rakuten Insights SDK.
 */
public func configure() {
    let configurationClient = ConfigurationClient(commonUtility: CommonUtility())
    
    // (TODO: Daniel Tam) remove if statement later.
    if configurationClient.checkConfigurationServer() {
        print("Enable SDK.")
    } else {
        print("Disable SDK.")
    }
}
