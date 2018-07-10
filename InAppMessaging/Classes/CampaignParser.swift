//
//  CampaignParser.swift
//  InAppMessaging
//
//  Created by Tam, Daniel a on 7/9/18.
//

import Foundation

class CampaignParser {
    
    internal func findMatchingTrigger(trigger: String, campaignListOptional: [CampaignList]?) -> CampaignData? {
        
        guard let campaignList = campaignListOptional else {
            return nil
        }
        
        for campaign in campaignList {
            print(campaign.campaignData.trigger)
        }
        
//        do {
//            let jsonData = try JSON(data: campaignList)
//
//            print(campaign)
//        } catch let error {
//            print("Failed to parse json:", error)
//        }
//
//        for campaign in campaignList {
//            print(campaign)
//        }
        return nil
    }
}
