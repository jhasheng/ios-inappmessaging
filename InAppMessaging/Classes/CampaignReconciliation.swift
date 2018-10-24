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
//        let campaignList = CampaignRepository.list
//        let eventList = EventRepository.list
        
        // Create an unique list of event by their eventType. If it is a 4, it will be by name.
        
        
        

        for campaign in CampaignRepository.list {
            for trigger in campaign.campaignData.triggers {
                for event in EventRepository.list {
                    

                } // Event
            } // Trigger
            ReadyCampaignRepository.addCampaign(campaign)
        } // Campaign
        print("TEST: \(ReadyCampaignRepository.list)")
        print("TEST: \(ReadyCampaignRepository.list.count)")

    }
    
    /**
     * Helps reconciliation process by creating an list of of unique events to match.
     */
    private func generateUniqueEventList() {
        var eventTypes: Set<EventType> = [] // To store event types that aren't custom.
        var eventNames: Set<String> = [] // To store custom event type.
        
        for event in EventRepository.list {
            if event.eventType != EventType.custom {
                eventTypes.insert(event.eventType)
            } else {
                // Grab string name.
            }
        }
        
    }
}

/**
 * If matched, move to next trigger.
 */
