struct IndentificationManager {
    static var userId = [[String: String]]()
    
    static func registerId(_ idType: Identification, _ id: String) {
        
        var typeOptional: String?
        
        switch idType {
            case .easyId:
                typeOptional = "easyId"
            case .rakutenId:
                typeOptional = "rakutenId"
        }
        
        if let type = typeOptional {
            self.userId.append([
                "type": type,
                "id": id
            ])
        }
    }
}
