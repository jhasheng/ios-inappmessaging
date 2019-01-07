/**
 * Class to handle the logic of checking if a campaign is ready to be displayed.
 */
struct CampaignReconciliation {
    
    /**
     * Cross references the list of campaigns from CampaignRepository
     * and the list of events in EventRepository and check if any campaigns are
     * ready to be displayed. This method is called when:
     * 1) MessageMixerClient retrieves a new list from the ping endpoint.
     * 2) Hostapp logs an event.
     */
    static func reconciliate() {
                
        // Create an unique list of event by their eventType and eventName.
        let uniqueList = generateUniqueEventList()
        
        // Loop through every campaign in the list and check if it is ready to be displayed.
        for campaign in CampaignRepository.list {
            if isCampaignReady(campaign, uniqueList) {
                ReadyCampaignRepository.addCampaign(campaign)
            }
        }
    }
    
    /**
     * Helps reconciliation process by creating an list of of unique eventType and eventName to match.
     * @returns { (uniqueEventTypes: Set<Int>, uniqueEventNames: Set<String>) } Tuple of unique event types and names set.
     */
    private static func generateUniqueEventList() -> (uniqueEventTypes: Set<Int>, uniqueEventNames: Set<String>) {
        var eventTypes: Set<Int> = [] // To store event types that aren't custom.
        var eventNames: Set<String> = [] // To store custom event names.
        
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
     * There are two requirements for a campaign to be 'ready':
     * 1) Campaign was not shown before.
     * 2) Campaign has all of its triggers activated. E.G If there are two triggers in a campaign,
     * both must be triggered.
     * @param { campaign: Campaign } the campaign to check.
     * @param { (uniqueEventTypes: Set<Int>, uniqueEventNames: Set<String>) } the tuple of unique eventTypes/eventNames.
     * @param { Bool } true if campaign is ready to be displayed, else false.
     */
    private static func isCampaignReady(
        _ campaign: Campaign,
        _ list: (uniqueEventTypes: Set<Int>, uniqueEventNames: Set<String>)) -> Bool {
        
            // Secondary check for test campaigns. If theres no triggers, it has to be a test campaign.
            guard let triggers = campaign.campaignData.triggers else {
                return true
            }
        
            // If the campaign has reached max impression count within a session, don't show it again.
            if isMaxImpressionReached(forCampaign: campaign) {
                return false
            }
        
            for trigger in triggers {
                // If the trigger is not custom, check the uniqueEventTypes list for matches.
                if trigger.eventType != EventType.custom.rawValue {
                    if !list.uniqueEventTypes.contains(trigger.eventType) {
                        return false
                    }
                } else {
                    guard let eventName = CampaignParser.getCustomEventName(trigger) else {
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
    
    /**
     * Verifies that the campaign that is being worked on has not reached its max impression count within a session.
     * @param { campaign: Campaign } campaign to check for impression count.
     * @returns { Bool } returns true if the campaign's impression count has been reached and false if not.
     */
    private static func isMaxImpressionReached(forCampaign campaign: Campaign) -> Bool {
        return DisplayedCampaignRepository.getDisplayedCount(forCampaign: campaign) >= campaign.campaignData.maxImpressions
    }
}
