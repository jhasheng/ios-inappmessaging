// Class that has public methods for host application to call.
/**
 * Function to called by host application to initialize Rakuten Insights SDK.
 */
public func configure() -> Bool {
    
    let serverConfiguration = ServerConfiguration(commonUtility: CommonUtility())
    
    if serverConfiguration.checkConfigurationServer() {
        print("Enable SDK.")
        return true
    } else {
        print("Disable SDK.")
        return false
    }

    return true
}
