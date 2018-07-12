/**
 * Data model for Campaign response.
 */
struct CampaignResponse: Decodable {
    let nextPing: Int
    let data: [CampaignList]
    
    enum CodingKeys: String, CodingKey {
        case nextPing = "next_ping"
        case data
    }
}

struct CampaignList: Decodable {
    let campaignData: CampaignData
    
    enum CodingKeys: String, CodingKey {
        case campaignData = "campaign_data"
    }
}

struct CampaignData: Decodable {
    let campaignId: String
    let type: String
    let trigger: [Trigger]
    let messagePayload: MessagePayload
    
    enum CodingKeys: String, CodingKey {
        case campaignId = "campaign_id"
        case type
        case trigger
        case messagePayload = "message_payload"
    }
}

struct Trigger: Decodable {
    let type: String
    let event: String
    let displayDelay: Int
    
    enum CodingKeys: String, CodingKey {
        case type
        case event
        case displayDelay = "display_delay"
    }
}

struct MessagePayload: Decodable {
    let title: String
    let messageBody: String
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
        case messageBody = "message_body"
        case header
        case titleColor = "title_color"
        case headerColor = "header_color"
        case messageBodyColor = "message_body_color"
        case backgroundColor = "background_color"
        case frameColor = "frame_color"
        case resource
        case messageSettings = "message_settings"
    }
}

struct Resource: Decodable {
    let assetsUrl: String
    let imageUrl: String
    let cropType: String
    
    enum CodingKeys: String, CodingKey {
        case assetsUrl = "assets_url"
        case imageUrl = "image_url"
        case cropType = "crop_type"
    }
}

struct MessageSettings: Decodable {
    let displaySettings: DisplaySettings
    let controlSettings: ControlSettings
    
    enum CodingKeys: String, CodingKey {
        case displaySettings = "display_settings"
        case controlSettings = "control_settings"
    }
}

struct DisplaySettings: Decodable {
    let orientation: String
    let slideFrom: String
    let campaignEndTime: Int
    let textAlign: String
    
    enum CodingKeys: String, CodingKey {
        case orientation
        case slideFrom = "slide_from"
        case campaignEndTime = "campaign_end_time"
        case textAlign = "text_align"
    }
}

struct ControlSettings: Decodable {
    let button: [Button]
    
    enum CodingKeys: String, CodingKey {
        case button
    }
}

struct Button: Decodable {
    let buttonText: String
    let buttonTextColor: String
    let buttonBackgroundColor: String
    let buttonBehavior: ButtonBehavior
    
    enum CodingKeys: String, CodingKey {
        case buttonText = "button_text"
        case buttonTextColor = "button_text_color"
        case buttonBackgroundColor = "button_background_color"
        case buttonBehavior = "button_behavior"
    }
}

struct ButtonBehavior: Decodable {
    let action: String
    let uri: String
    
    enum CodingKeys: String, CodingKey {
        case action
        case uri
    }
}
