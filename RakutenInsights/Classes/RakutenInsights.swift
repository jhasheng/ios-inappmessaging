// Class that has public methods for host application to call.

/**
 * Function to called by host application to initialize Rakuten Insights SDK.
 */
public func configure() {
    
    guard let enabledFlag = checkConfigurationServer() else {
        return
    }
    
    if enabledFlag {
        print("enabled")
        // Swizzle everything.
    } else {
        print("disabled")
        // Do nothing.
    }
}
