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
        case campaignData = "campaignData"
    }
}

struct CampaignData: Decodable {
    let campaignId: String
    let type: String
    let triggers: [Trigger]
    let messagePayload: MessagePayload
    
    enum CodingKeys: String, CodingKey {
        case campaignId = "campaignId"
        case type
        case triggers
        case messagePayload = "messagePayload"
    }
}

struct Trigger: Decodable {
    let type: String
    let event: String
    let displayDelay: Int
    
    enum CodingKeys: String, CodingKey {
        case type
        case event
        case displayDelay = "displayDelay"
    }
}

struct MessagePayload: Decodable {
    let title: String
    let messageBody: String?
    let header: String
    let titleColor: String
    let headerColor: String
    let messageBodyColor: String
    let backgroundColor: String
    let frameColor: String
    let resource: Resource
    let messageSettings: MessageSettings
    
    enum CodingKeys: String, CodingKey {
        case title
        case messageBody = "messageBody"
        case header
        case titleColor = "titleColor"
        case headerColor = "headerColor"
        case messageBodyColor = "messageBodyColor"
        case backgroundColor = "backgroundColor"
        case frameColor = "frameColor"
        case resource
        case messageSettings = "messageSettings"
    }
}

struct Resource: Decodable {
    let assetsUrl: String?
    let imageUrl: String?
    let cropType: String
    
    enum CodingKeys: String, CodingKey {
        case assetsUrl = "assetsUrl"
        case imageUrl = "imageUrl"
        case cropType = "cropType"
    }
}

struct MessageSettings: Decodable {
    let displaySettings: DisplaySettings
    let controlSettings: ControlSettings?
    
    enum CodingKeys: String, CodingKey {
        case displaySettings = "displaySettings"
        case controlSettings = "controlSettings"
    }
}

struct DisplaySettings: Decodable {
    let orientation: String
    let slideFrom: String?
    let endTimeMillis: Int
    let textAlign: String
    
    enum CodingKeys: String, CodingKey {
        case orientation
        case slideFrom = "slideFrom"
        case endTimeMillis
        case textAlign = "textAlign"
    }
}

struct ControlSettings: Decodable {
    let button: [Button]
    
    enum CodingKeys: String, CodingKey {
        case button
    }
}

struct Button: Decodable {
    let buttonText: String?
    let buttonTextColor: String?
    let buttonBackgroundColor: String?
    let buttonBehavior: ButtonBehavior
    
    enum CodingKeys: String, CodingKey {
        case buttonText = "buttonText"
        case buttonTextColor = "buttonTextColor"
        case buttonBackgroundColor = "buttonBackgroundColor"
        case buttonBehavior = "buttonBehavior"
    }
}

struct ButtonBehavior: Decodable {
    let action: String?
    let uri: String
    
    enum CodingKeys: String, CodingKey {
        case action
        case uri
    }
}
