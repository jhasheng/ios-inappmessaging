//

internal func getAppId() -> String? {
    guard let appAppName = Bundle.main.infoDictionary?["CFBundleIdentifier"]  as? String else {
        #if DEBUG
            assertionFailure("Failed to retrieve CFBundleIdentifier.")
        #endif
        return nil
    }
    
    return appAppName
}

internal func getAppVersion() -> String? {
    guard let appVersion = Bundle.main.infoDictionary?["CFBundleVersion"]  as? String else {
        #if DEBUG
            assertionFailure("Failed to retrieve CFBundleVersion.")
        #endif
        return nil
    }
    
    return appVersion
}
