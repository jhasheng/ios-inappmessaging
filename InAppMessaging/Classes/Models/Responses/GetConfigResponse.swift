/**
 * Data model for configuration server response.
 */
struct GetConfigResponse: Decodable {
    let data: ConfigData
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}

struct ConfigData: Decodable {
    let enabled: Bool
    let endpoints: EndpointURL
    
    enum CodingKeys: String, CodingKey {
        case enabled
        case endpoints
    }
}

struct EndpointURL: Decodable {
    let ping: String
    let displayPermission: String?
    
    enum CodingKeys: String, CodingKey {
        case ping
        case displayPermission
    }
}
