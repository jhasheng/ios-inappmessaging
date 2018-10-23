/**
 * Cross references the list of campaigns from CampaignRepository
 * and the list of events in EventRepository and check if any campaigns are
 * ready to be displayed. There are two requirements for a campaign to be 'ready':
 * 1) Campaign was not shown before
 * 2) Campaign has all of its triggers activated. E.G If there are two triggers in a campaign,
 * both must be triggered.
 */
struct CampaignReconciliation {
    
    /**
     * Cross references the list of campaigns from CampaignRepository
     * and the list of events in EventRepository and check if any campaigns are
     * ready to be displayed. There are two requirements for a campaign to be 'ready':
     * 1) Campaign was not shown before
     * 2) Campaign has all of its triggers activated. E.G If there are two triggers in a campaign,
     * both must be triggered.
     */
    static func reconciliate() {
        for campaign in CampaignRepository.list {
            middleLoop: for trigger in campaign.campaignData.triggers {
                for event in EventRepository.list {
                    if trigger.eventType != event.eventType.rawValue {
                        break middleLoop;
                    }
                    
                    
                } // Event
                ReadyCampaignRepository.addCampaign(campaign)
            } // Trigger
            
        } // Campaign
    }
}
