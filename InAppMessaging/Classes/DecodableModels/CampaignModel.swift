/**
 * Data model for Campaign response.
 */
struct CampaignResponse: Decodable {
    let nextPingMillis: Int
    let data: [Campaign]
    
    enum CodingKeys: String, CodingKey {
        case nextPingMillis
        case data
    }
}

struct Campaign: Decodable {
    let campaignData: CampaignData
    
    enum CodingKeys: String, CodingKey {
        case campaignData
    }
}

struct CampaignData: Decodable {
    let campaignId: String
    let type: String
    let triggers: [Trigger]
    let messagePayload: MessagePayload
    
    enum CodingKeys: String, CodingKey {
        case campaignId
        case type
        case triggers
        case messagePayload
    }
}

struct Trigger: Decodable {
    let type: String
    let event: String
    let displayDelay: Int
    
    enum CodingKeys: String, CodingKey {
        case type
        case event
        case displayDelay
    }
}

struct MessagePayload: Decodable {
    let title: String
    let messageBody: String?
    let header: String?
    let titleColor: String
    let headerColor: String
    let messageBodyColor: String
    let backgroundColor: String
    let frameColor: String
    let resource: Resource
    let messageSettings: MessageSettings
    
    enum CodingKeys: String, CodingKey {
        case title
        case messageBody
        case header
        case titleColor
        case headerColor
        case messageBodyColor
        case backgroundColor
        case frameColor
        case resource
        case messageSettings
    }
}

struct Resource: Decodable {
    let assetsUrl: String?
    let imageUrl: String?
    let cropType: String
    
    enum CodingKeys: String, CodingKey {
        case assetsUrl
        case imageUrl
        case cropType
    }
}

struct MessageSettings: Decodable {
    let displaySettings: DisplaySettings
    let controlSettings: ControlSettings?
    
    enum CodingKeys: String, CodingKey {
        case displaySettings
        case controlSettings
    }
}

struct DisplaySettings: Decodable {
    let orientation: String
    let slideFrom: String?
    let endTimeMillis: Int
    let textAlign: String
    
    enum CodingKeys: String, CodingKey {
        case orientation
        case slideFrom
        case endTimeMillis
        case textAlign
    }
}

struct ControlSettings: Decodable {
    let buttons: [Button]?
    
    enum CodingKeys: String, CodingKey {
        case buttons
    }
}

struct Button: Decodable {
    let buttonText: String?
    let buttonTextColor: String?
    let buttonBackgroundColor: String?
    let buttonBehavior: ButtonBehavior
    
    enum CodingKeys: String, CodingKey {
        case buttonText
        case buttonTextColor
        case buttonBackgroundColor
        case buttonBehavior
    }
}

struct ButtonBehavior: Decodable {
    let action: Int
    let uri: String
    
    enum CodingKeys: String, CodingKey {
        case action
        case uri
    }
}
