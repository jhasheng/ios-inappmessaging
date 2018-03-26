//// Helper class to provide information about the application.
//
///**
// * Function to retrieve application bundle name.
// * @returns { Optional String } application ID.
// */
//internal func getAppId() -> String? {
//    guard let appAppName = Bundle.main.infoDictionary?["CFBundleIdentifier"]  as? String else {
//        #if DEBUG
//            assertionFailure("Failed to retrieve CFBundleIdentifier.")
//        #endif
//        return nil
//    }
//
//    return appAppName
//}
//
///**
// * Function to retrieve application bundle name
// */
//internal func getAppVersion() -> String? {
//    guard let appVersion = Bundle.main.infoDictionary?["CFBundleVersion"]  as? String else {
//        #if DEBUG
//            assertionFailure("Failed to retrieve CFBundleVersion.")
//        #endif
//        return nil
//    }
//
//    return appVersion
//}

