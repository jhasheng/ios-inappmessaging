/**
 * Struct to handle registering different IDs that Rakuten supports.
 */
struct IndentificationManager {
    static var idList = [[String: AnyHashable]]()
    
    /**
     * Register the ID to the static userId field which will be used in request bodies.
     * @param { idType: Identification } type of id to be used.
     * @param { id: String } value of the id.
     */
    static func registerId(_ idType: Identification, _ id: String) {
        self.idList.append([
            "type": idType.rawValue,
            "id": id
        ])
    }
}
