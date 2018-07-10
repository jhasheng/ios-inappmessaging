//
//  CampaignParser.swift
//  InAppMessaging
//
//  Created by Tam, Daniel a on 7/9/18.
//

import Foundation

class CampaignParser {
    
    /**
     * Sear
     */
    internal func findMatchingTrigger(trigger: String, campaignListOptional: [CampaignList]?) -> CampaignData? {
        
        guard let campaignList = campaignListOptional else {
            return nil
        }
        
        for campaign in campaignList {
            for campaignTrigger in campaign.campaignData.trigger {
                if trigger == campaignTrigger.event {
                    print(campaign.campaignData)
                    return campaign.campaignData
                }
            }
        }

        return nil
    }
}
