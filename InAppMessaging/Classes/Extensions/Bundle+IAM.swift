/**
 * Extension to Bundle class to provide computed properties required by InAppMessaging.
 */
extension Bundle {
    
    static var applicationId: String? {
        return Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String
    }
    
    static var appVersion: String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    static var inAppSdkVersion: String? {
        return Bundle.main.infoDictionary?[Constants.Bundle.SDKVersion] as? String
    }
    
    static var inAppSubscriptionId: String? {
        return Bundle.main.infoDictionary?[Constants.Bundle.SubscriptionID] as? String
    }
}
