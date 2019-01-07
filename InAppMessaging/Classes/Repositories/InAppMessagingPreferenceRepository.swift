/**
 * Repository to hold IAMPreference.
 */
struct IAMPreferenceRepository {
    static var preference: IAMPreference?
    
    static func setPreference(with preference: IAMPreference?) {
        self.preference = preference
    }
    
    /**
     * Method to convert the preferences object into
     * an array that can be sent to the backend.
     * @returns { [UserIdentifier] } List of IDs to send in request bodies.
     */
    static func getUserIdentifiers() -> [UserIdentifier] {
       
        var userIdentifiers = [UserIdentifier]()

        // Check if preference is empty or not.
        guard let preference = self.preference else {
            return userIdentifiers
        }
        
        // Check if rakutenId is populated in preference.
        if let rakutenId = preference.rakutenId {
            userIdentifiers.append(
                UserIdentifier(type: Identification.rakutenId.rawValue, id: rakutenId)
            )
        }
        
        // Check if userId is populated in preference.
        if let userId = preference.userId {
            userIdentifiers.append(
                UserIdentifier(type: Identification.userId.rawValue, id: userId)
            )
        }
        
        return userIdentifiers
    }
    
    /**
     * Method to retrieve RAE access token in preference object.
     * @returns { String? } optional string of access token.
     */
    static func getAccessToken() -> String? {
        guard let accessToken = self.preference?.accessToken else {
            return nil
        }
        
        return accessToken
    }
}
