/**
 * Data model for Campaign response.
 */
struct PingResponse: Decodable {
    let nextPingMillis: Int
    let data: Set<Campaign>
    
    enum CodingKeys: String, CodingKey {
        case nextPingMillis
        case data
    }
}

struct Campaign: Decodable, Hashable {

    let campaignData: CampaignData
    var hashValue: Int {
        return campaignData.campaignId.hashValue
    }
    
    enum CodingKeys: String, CodingKey {
        case campaignData
    }
    
    static func == (lhs: Campaign, rhs: Campaign) -> Bool {
        return lhs.campaignData == rhs.campaignData
    }
}

struct CampaignData: Decodable, Equatable {
    
    let campaignId: String
    let type: Int
    let triggers: [Trigger]
    let isTest: Bool
    let messagePayload: MessagePayload
    
    enum CodingKeys: String, CodingKey {
        case campaignId
        case type
        case triggers
        case isTest
        case messagePayload
    }
    
    static func == (lhs: CampaignData, rhs: CampaignData) -> Bool {
        return lhs.campaignId == rhs.campaignId
    }
}

struct Trigger: Decodable {
    let type: Int
    let eventType: Int
    let attributes: [Attribute]
    
    enum CodingKeys: String, CodingKey {
        case type
        case eventType
        case attributes
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
    let cropType: Int
    
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
    let orientation: Int
    let slideFrom: Int
    let endTimeMillis: Int
    let textAlign: Int
    
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
    let uri: String?
    
    enum CodingKeys: String, CodingKey {
        case action
        case uri
    }
}
