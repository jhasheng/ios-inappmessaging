//
//  CampaignModel.swift
//  InAppMessaging
//
//  Created by Tam, Daniel a on 7/5/18.
//

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
    
}
