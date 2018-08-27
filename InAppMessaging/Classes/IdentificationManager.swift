/**
 * Struct to handle registering different IDs that Rakuten supports.
 */
struct IndentificationManager {
    static var userId = [[String: String]]()
    
    /**
     * Register the ID to the static userId field which will be used in request bodies.
     * @param { idType: Identification } type of id to be used.
     * @param { id: String } value of the id.
     */
    static func registerId(_ idType: Identification, _ id: String) {
        
        var typeOptional: String?
        
        switch idType {
            case .easyId:
                typeOptional = "easyId"
            case .rakutenId:
                typeOptional = "rakutenId"
            case .userId:
                typeOptional = "userId";
        }
        
        if let type = typeOptional {
            self.userId.append([
                "type": type,
                "id": id
            ])
        }
    }
}
