// Class that has public methods for host application to call.
/**
 * Function to called by host application to initialize Rakuten Insights SDK.
 */
public func configure() -> Bool {
    
    let commonUtility = CommonUtility()
    let serverConfiguration = ServerConfiguration(commonUtility: commonUtility)
    
    if serverConfiguration.checkConfigurationServer() {
        print("Enable SDK.")
        return true
    } else {
        print("Disable SDK.")
        return false
    }

    //initializeSdk()
    return true
}
