/**
 * Extension to provide additional utilities to the String classes thats needed by IAM.
 */
extension String {
    
    /**
     * Return the localized string provided by IAM's resource file.
     * @returns { String } the localized string.
     */
    var localized: String {
        let bundleID = "org.cocoapods.InAppMessaging"
        guard let path = Bundle(identifier: bundleID)?.resourcePath,
            let bundle = Bundle(path: path.appending("/InAppMessaging.bundle"))
        else {
            return self
        }
        
        return NSLocalizedString(self, bundle: bundle, comment: "")
    }
}
