//
//  CampaignParser.swift
//  InAppMessaging
//
//  Created by Tam, Daniel a on 7/9/18.
//

import Foundation

class CampaignParser {
    
    /**
     * Search through list of all campaigns' triggers to find the first matching campaign to return.
     * @param { trigger: String } The trigger name logged by the host app.
     * @param { campaignListOptional: [CampaignList]? } Optional array of the list of campaigns.
     * @returns { CampaignData? } Optional campaign with the matching trigger name.
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
