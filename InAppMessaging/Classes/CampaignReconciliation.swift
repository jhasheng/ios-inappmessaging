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
        
        // Split the CampaignRepository into two different sets of test and non-test campaigns.
        let campaignList = CampaignParser.splitCampaigns(campaigns: CampaignRepository.list)
        
        // Add all the test campaign into the ReadyCampaignRepository.
        ReadyCampaignRepository.addAllCampaigns(campaignList.testCampaigns)
        
        // Iterate through all the non-test campaigns to verify each one.
        for campaign in campaignList.nonTestCampaigns {
            
            // Check if maxImpressions has already been reached for this campaign.
            if isMaxImpressionReached(forCampaign: campaign) {
                continue
            }
            
//            for _ in getNumberOfTimesToDisplay(campaign) {
//                ReadyCampaignRepository.addCampaign(<#T##campaign: Campaign##Campaign#>)
//            }
            
            // Find out how many times are the triggers satisfied for this campaign.
            // Add to ReadyCampaignRepo.
//            for _ in getNumberOfTimesToDisplay(campaign) {
//
//            }
            
            
        }
        
        // Create an unique list of event by their eventType and eventName.
//        let uniqueList = generateUniqueEventList()
        
        // Loop through every campaign in the list and check if it is ready to be displayed.
//        for campaign in CampaignRepository.list {
//            if isCampaignReady(campaign, uniqueList) {
//                ReadyCampaignRepository.addCampaign(campaign)
//            }
//        }
    }
    
    private static func getNumberOfTimesToDisplay(_ campaign: Campaign) -> Int {
        let maxImpressions = campaign.campaignData.maxImpressions
        let numberOfTimesTriggersAreSatisfied = getNumberOfTimesTriggersAreSatisfied(campaign)
        
        // The number of times the campaign should be displayed is either the max impression
        // if it the number is lower than the number of times the trigger are satisfied
        // or the number of times satisfied if it is lower than the max impression.
        var numberOfTimesShouldBeDisplayed =
            maxImpressions < numberOfTimesTriggersAreSatisfied ?
                maxImpressions : numberOfTimesTriggersAreSatisfied
        
        // Subtract the result with the amount of times already shown.
        return numberOfTimesShouldBeDisplayed - DisplayedCampaignRepository.getDisplayedCount(forCampaign: campaign)
    }
    
//    /**
//     * Helps reconciliation process by creating a set of unique eventType and eventName to match.
//     * @returns { (uniqueEventTypes: Set<Int>, uniqueEventNames: Set<String>) } Tuple of unique event types and names set.
//     */
//    private static func generateUniqueEventList() -> (uniqueEventTypes: Set<Int>, uniqueEventNames: Set<String>) {
//        var eventTypes: Set<Int> = [] // To store event types that aren't custom.
//        var eventNames: Set<String> = [] // To store custom event names.
//
//        for event in EventRepository.list {
//            if event.eventType != EventType.custom {
//                eventTypes.insert(event.eventType.rawValue)
//            } else {
//                eventNames.insert(event.eventName)
//            }
//        }
//
//        return (eventTypes,eventNames)
//    }
    
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
//    private static func isCampaignReady(
//        _ campaign: Campaign,
//        _ list: (uniqueEventTypes: Set<Int>, uniqueEventNames: Set<String>)) -> Bool {
//
//            // Secondary check for test campaigns. If theres no triggers, it has to be a test campaign.
//            guard let triggers = campaign.campaignData.triggers else {
//                return true
//            }
//
//            // If the campaign has reached max impression count within a session, don't show it again.
//            if isMaxImpressionReached(forCampaign: campaign) {
//                return false
//            }
//
//            // Check for the number of times the triggers are satisfied.
//
//
//            for trigger in triggers {
//                // If the trigger is not custom, check the uniqueEventTypes list for matches.
//                if trigger.eventType != EventType.custom.rawValue {
//                    if !list.uniqueEventTypes.contains(trigger.eventType) {
//                        return false
//                    }
//                } else {
//                    guard let eventName = CampaignParser.getCustomEventName(trigger) else {
//                        return false
//                    }
//
//                    // If the trigger is custom, check the uniqueEventNames list for matching names.
//                    if !list.uniqueEventNames.contains(eventName) {
//                        return false
//                    }
//                }
//            }
//
//            return true
//    }
    
    /**
     * Verifies that the campaign that is being worked on has not reached its max impression count within a session.
     * @param { campaign: Campaign } campaign to check for impression count.
     * @returns { Bool } returns true if the campaign's impression count has been reached and false if not.
     */
    private static func isMaxImpressionReached(forCampaign campaign: Campaign) -> Bool {
        return DisplayedCampaignRepository.getDisplayedCount(forCampaign: campaign) >= campaign.campaignData.maxImpressions
    }
    
    /**
     * Create a hashmap of eventType(int) to list of events. This helps reconciliation process
     * by counting up the times an event has been logged by the host app.
     * @param { eventList: [Event] } the list of event to create a mapping of.
     * @returns { [Int: [Event]] } dictionary of string to list of events.
     */
    private static func createEventMap(_ eventList: [Event]) -> [Int: [Event]] {
        var eventMap = [Int: [Event]]()
        
        // Loop through the event list to create the mapping.
        for event in eventList {
            let eventType = event.eventType.rawValue

            // If the eventName already exist in the mapping, append the element.
            if eventMap.keys.contains(eventType) {
                eventMap[eventType]?.append(event)
            } else {
                // else, create a new field and list.
                eventMap[eventType] = [event]
            }
        }
        
        return eventMap
    }
    
    private static func getNumberOfTimesTriggersAreSatisfied(_ campaign: Campaign) -> Int {
        
        // Get the list of triggers off the campaign.
        guard let campaignTriggers = campaign.campaignData.triggers else {
            #if DEBUG
                print("InAppMessaging: campaign has no triggers.")
            #endif
            return 0
        }
        
        let localEventMapping = createEventMap(EventRepository.list) // Mapping of local events.
        var campaignTriggerListMapping = [Int: Int]() // Mapping of the counter for each trigger needed for a campaign.
        
        for trigger in campaignTriggers {
            let eventType = trigger.eventType
            
            // If a trigger is already added in the mapping, increment it.
            if campaignTriggerListMapping.keys.contains(trigger.eventType) {
                campaignTriggerListMapping[eventType]? += 1
            } else {
                // else, add a new entry with the counter as 1.
                campaignTriggerListMapping[eventType] = 1
            }
        }
        
        var numberOfTimesSatisfied: Int?
        
        // Divide the event mapping with satisfiedTriggersCountMapping to
        // get the number of times the set of triggers are satisfied.
        // Find the lowest count satisfied trigger by dividing local event mapping and satisfiedTriggersCountMapping.
        for (eventType, count) in campaignTriggerListMapping {
            // If the local event mapping contains an entry of the campaign's trigger.
            if let eventTypeMappingCount = localEventMapping[eventType]?.count {
                // Swift, by default, rounds down for Int type when dividing.
                numberOfTimesSatisfied = eventTypeMappingCount / count
            } else {
                // else if theres no entry, then the campaign's trigger has not been fully satisfied.
                return 0
            }
        }

        return numberOfTimesSatisfied ?? 0
    }
    
}
