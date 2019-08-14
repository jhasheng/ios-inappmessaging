/**
 * Data model for Campaign response.
 */
struct PingResponse: Decodable {
    let nextPingMillis: Int
    let currentPingMillis: Int
    let data: Set<Campaign>
}

struct Campaign: Decodable, Hashable {

    let campaignData: CampaignData
    var hashValue: Int {
        return campaignData.campaignId.hashValue
    }
    
    static func == (lhs: Campaign, rhs: Campaign) -> Bool {
        return lhs.campaignData == rhs.campaignData
    }
}

struct CampaignData: Decodable, Equatable {
    
    let campaignId: String
    let maxImpressions: Int
    let type: Int
    let triggers: [Trigger]?
    let isTest: Bool
    let messagePayload: MessagePayload
    
    static func == (lhs: CampaignData, rhs: CampaignData) -> Bool {
        return lhs.campaignId == rhs.campaignId
    }
}

struct Trigger: Decodable {
    let type: CampaignTriggerType
    let eventType: EventType
    let eventName: String
    let attributes: [TriggerAttribute]
}

struct MessagePayload: Decodable {
    let title: String
    let messageBody: String?
    let messageLowerBody: String?
    let header: String?
    let titleColor: String
    let headerColor: String
    let messageBodyColor: String
    let backgroundColor: String
    let frameColor: String
    let resource: Resource
    let messageSettings: MessageSettings
}

struct Resource: Decodable {
    let assetsUrl: String?
    let imageUrl: String?
    let cropType: Int
}

struct MessageSettings: Decodable {
    let displaySettings: DisplaySettings
    let controlSettings: ControlSettings?
}

struct DisplaySettings: Decodable {
    let orientation: Int
    let slideFrom: SlideFromEnum?
    let endTimeMillis: Int
    let textAlign: Int
}

struct ControlSettings: Decodable {
    let buttons: [Button]?
    let content: Content?
}

struct Content: Decodable {
    let onClickBehavior: OnClickBehavior
    let campaignTrigger: Trigger?
}

struct OnClickBehavior: Decodable {
    let action: ActionType
    let uri: String?
}

struct Button: Decodable {
    let buttonText: String
    let buttonTextColor: String
    let buttonBackgroundColor: String
    let buttonBehavior: ButtonBehavior
    let campaignTrigger: Trigger?
}

struct ButtonBehavior: Decodable {
    let action: ActionType
    let uri: String?
}
