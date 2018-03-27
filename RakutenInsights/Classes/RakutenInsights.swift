// Class that has public methods for host application to call.

/**
 * Function to called by host application to initialize Rakuten Insights SDK.
 */
public func configure() {
    if checkConfigurationServer() {
        print("Enable SDK.")
    } else {
        print("Disable SDK.")
    }
}
    
