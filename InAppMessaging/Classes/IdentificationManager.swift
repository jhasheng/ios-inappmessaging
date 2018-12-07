/**
 * Struct to handle registering different IDs that Rakuten supports.
 */
struct IndentificationManager {
    static var userIdentifiers = [UserIdentifier]()
    static var accessToken: String? // RAE Access token from RAuthentication.
    
    /**
     * Register the ID to the static userId field which will be used in request bodies.
     * @param { idType: Identification } type of id to be used.
     * @param { id: String } value of the id.
     */
    static func registerId(_ idType: Identification, _ id: String) {
        
        // Remove existing ID of same type.
        removeExistingId(idType)
        
        userIdentifiers.append(
            UserIdentifier(type: idType.rawValue, id: id)
        )
    }
    
    /**
     * Validates that the SDK is only storing a single ID of a certain type.
     * E.G The SDK will not store two different easyId.
     * This is to ensure proper behavior if a single device is used for multiple accounts.
     * @param { idType: Identification } idType to search and remove.
     */
    static func removeExistingId(_ idType: Identification) {
        for (index, userId) in userIdentifiers.enumerated() {
            if userId.type == idType.rawValue {
                userIdentifiers.remove(at: index)
            }
        }
    }
    
    /**
     * Register the access token with IAM.
     * @param { token: String } value of the token.
     */
    static func registerAccessToken(_ token: String) {
        if !token.isEmpty {
            accessToken = token
        }
    }
}

