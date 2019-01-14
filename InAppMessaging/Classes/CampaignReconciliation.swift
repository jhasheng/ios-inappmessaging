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
                print("max imp reached")
                continue
            }
            
            // Find out how many times should the campaign be added.
            // Add to ReadyCampaignRepo.
            print("times to display: \(getNumberOfTimesToDisplay(campaign))")
            for _ in 0..<getNumberOfTimesToDisplay(campaign) {
                ReadyCampaignRepository.addCampaign(campaign)
                print("Size: \(ReadyCampaignRepository.list.count)")
            }
        }
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
        var eventMap: [Int: [Event]] = [:]
        
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
        
        var lowestNumberOfTimesSatisfied = Int.max
        
        // Divide the event mapping with satisfiedTriggersCountMapping to
        // get the number of times the set of triggers are satisfied.
        // Find the lowest count satisfied trigger by dividing local event mapping and satisfiedTriggersCountMapping.
        for (eventType, count) in campaignTriggerListMapping {
            // If the local event mapping contains an entry of the campaign's trigger.
            if let eventTypeMappingCount = localEventMapping[eventType]?.count {
                // Swift, by default, rounds down for Int type when dividing.
                let satisfiedCountForEventType = eventTypeMappingCount / count
                
                // Find the lowest count from the list of triggers. E.G If a campaign
                // has 2 triggers; one satisfied 3 times and the other 2 times, return 2.
                lowestNumberOfTimesSatisfied =
                    lowestNumberOfTimesSatisfied > satisfiedCountForEventType ?
                        satisfiedCountForEventType : lowestNumberOfTimesSatisfied
                
            } else {
                // else if theres no entry, then the campaign's trigger has not been fully satisfied.
                return 0
            }
        }

        return lowestNumberOfTimesSatisfied ?? 0
    }
}
