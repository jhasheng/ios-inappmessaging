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
        
        // Create an unique list of event by their eventType. If it is a 4, it will be by name.
        let uniqueList = generateUniqueEventList()
        
        for campaign in CampaignRepository.list {
            if isCampaignReady(campaign, uniqueList) {
                ReadyCampaignRepository.addCampaign(campaign)
            }
        }
        
        
        
        print("TEST: \(ReadyCampaignRepository.list)")
        print("TEST: \(ReadyCampaignRepository.list.count)")

    }
    
    /**
     * Helps reconciliation process by creating an list of of unique events to match.
     */
    private static func generateUniqueEventList() -> (uniqueEventTypes: Set<Int>, uniqueEventNames: Set<String>) {
        var eventTypes: Set<Int> = [] // To store event types that aren't custom.
        var eventNames: Set<String> = [] // To store custom event type.
        
        for event in EventRepository.list {
            if event.eventType != EventType.custom {
                eventTypes.insert(event.eventType.rawValue)
            } else {
                eventNames.insert(event.eventName)
            }
        }
        
        return (eventTypes,eventNames)
 
    }
    
    /**
     * Method to check if campaign is ready to be displayed or not.
     */
    private static func isCampaignReady(
        _ campaign: Campaign,
        _ list: (uniqueEventTypes: Set<Int>, uniqueEventNames: Set<String>)) -> Bool {
        
            for trigger in campaign.campaignData.triggers {
                // If the trigger is not custom, check the uniqueEventTypes list for matches.
                if trigger.eventType != EventType.custom.rawValue {
                    if !list.uniqueEventTypes.contains(trigger.eventType) {
                        return false
                    }
                } else {
                    guard let eventName = trigger.eventName else {
                        return false
                    }
                    
                    // If the trigger is custom, check the uniqueEventNames list for matching names.
                    if !list.uniqueEventNames.contains(eventName) {
                        return false
                    }
                }
            }
        
            return true
    }
}
