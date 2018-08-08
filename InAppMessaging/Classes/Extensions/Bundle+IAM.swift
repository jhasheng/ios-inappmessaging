/**
 * Extension to Bundle class to provide computed properties required by InAppMessaging.
 */
extension Bundle {
    
    static var applicationId: String? {
        return Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String
    }
    
    static var appBuildVersion: String? {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    }
    
    static var inAppSdkVersion: String? {
        return Bundle.main.infoDictionary?[Keys.Bundle.SDKVersion] as? String
    }
    
    static var inAppSubscriptionId: String? {
        return Bundle.main.infoDictionary?[Keys.Bundle.SubscriptionID] as? String
    }
    
    static var inAppConfigUrl: String? {
        return Bundle.main.infoDictionary?[Keys.URL.ConfigServerURL] as? String
    }
}
