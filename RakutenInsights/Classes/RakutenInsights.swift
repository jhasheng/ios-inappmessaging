// Class that has public methods for host application to call.
/**
 * Function to called by host application to initialize Rakuten Insights SDK.
 */
public func configure() -> Bool {
//    if checkConfigurationServer() {
//        print("Enable SDK.")
//        return true
//    } else {
//        print("Disable SDK.")
//        return false
//    }

    RakuInsights()
    return true
}

func RakuInsights() {
    let boolFlag = checkConfigurationServer(param1: retrieveFromMainBundle(forKey: "RakutenInsightsConfigURL")?)
}
