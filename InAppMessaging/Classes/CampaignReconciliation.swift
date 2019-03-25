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
        let campaignList = CampaignParser.splitCampaigns(campaigns: PingResponseRepository.list)
        
        // Add all the test campaign into the ReadyCampaignRepository.
        ReadyCampaignRepository.addAllCampaigns(campaignList.testCampaigns)
        
        // Iterate through all the non-test campaigns to verify each one.
        for campaign in campaignList.nonTestCampaigns {
            
            // Check if maxImpressions has already been reached for this campaign.
            if isMaxImpressionReached(forCampaign: campaign) {
                continue
            }
            
            // Add to ReadyCampaignRepo if the campaign's set of triggers are satisfied.
            // Message will not be added twice within one reconciliation process.
            if getNumberOfTimesToDisplay(campaign) > 0 {
                ReadyCampaignRepository.addCampaign(campaign)
            }
        }
    }
    
    /**
     * Retrieve the number of times a campaign should be displayed.
     * The logic involves checking three conditions:
     * 1) The maxImpression value for a specific campaign.
     * 2) The number of times a trigger is satisfied as a set.
     *    E.G 1 set is satisfied if all the triggers for a campaign is satisfied once.
     * 3) The number of times that the campaign has already been shown.
     * @param { campaign: Campaign } the campaign to check.
     * @returns { Int } the number of times to show this campaign.
     */
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
     * Create a hashmap of eventName(String) to list of events. This helps reconciliation process
     * by counting up the times an event has been logged by the host app.
     * @param { eventList: [Event] } the list of event to create a mapping of.
     * @returns { [String: [Event]] } dictionary of string to list of events.
     */
    private static func createEventMap(_ eventList: [Event]) -> [String: [Event]] {
        var eventMap: [String: [Event]] = [:]
        
        // Loop through the event list to create the mapping.
        for event in eventList {
//            let eventType = event.eventType.rawValue
            let eventName = event.eventName

            // If the eventName already exist in the mapping, append the element.
            if eventMap.keys.contains(eventName) {
                eventMap[eventName]?.append(event)
            } else {
                // else, create a new field and list.
                eventMap[eventName] = [event]
            }
        }
        
        return eventMap
    }
    
    /**
     * Retrieves the number of times a set of triggers is satisfied for a campaign.
     * @param { campaign: Campaign } campaign to check for.
     * @return { Int } the amount of times a set of trigger is satified.
     */
    private static func getNumberOfTimesTriggersAreSatisfied(_ campaign: Campaign) -> Int {
        
        // Get the list of triggers off the campaign.
        guard let campaignTriggers = campaign.campaignData.triggers else {
            #if DEBUG
                print("InAppMessaging: campaign has no triggers.")
            #endif
            return 0
        }
        
        // Create a local event mapping used to quickly match event and trigger names.
        let localEventMapping = createEventMap(EventRepository.list) // Mapping of local events. [String: [Event]]
        
        // Number of times the set of triggers must be satisfied.
        let numberOfTimesTriggersMustBeSatisfied = getNumberOfTimesTriggersMustBeSatisfied(campaign)
        
        // Mapping of already used events and its index.
        var mappingOfUsedEvents = [String: [Int]]()
        
        // Iterate through all the triggers for a specific campaign.
        for trigger in campaignTriggers {
            
            // The amount of times that the current trigger that is being iterated upon has been satisfied.
            var amountOfTimesSatisfied: Int = 0
            
            // Check if there is a record in the localEventMapping with the same trigger name.
            // If there is none, then the campaign's triggers cannot be fully satisfied.
            guard let listOfMatchingNameEvents  = localEventMapping[trigger.eventName] else {
                return 0
            }
            
            // Iterate through the list of events with matching event name.
            // See how many times each trigger is satisfied.
            for (index, event) in listOfMatchingNameEvents.enumerated() {
                
                // Check if this event was already used for previous triggers.
                // If it is, move onto the next event.
                if isEventAlreadyUsed(event: event, usedMapping: mappingOfUsedEvents) {
                    continue
                }
                
                // If the trigger is satisfied.
                if isTriggerSatisfied(trigger: trigger, event: event) {
                    
                    // Append this event to the mapping of used events so that it won't be used for other triggers.
                    if mappingOfUsedEvents.keys.contains(trigger.eventName) {
                        mappingOfUsedEvents[trigger.eventName]?.append(index)
                    } else {
                        mappingOfUsedEvents[trigger.eventName] = [index]
                    }
                    
                    // Increment the amount satisfied for this trigger.
                    amountOfTimesSatisfied += 1
                    
                    // If this trigger already exceeds the amount of times needed to be satified,
                    // move onto the next trigger.
                    if amountOfTimesSatisfied >= numberOfTimesTriggersMustBeSatisfied {
                        break
                    }
                }
            }
            
            // Now, we know the amount of times each trigger was satisfied.
        }
            
            // Match trigger name with the localEventMapping to grab the list of event
            
            // Iterate through list of event and check for any matching attribute, if any exists.
            
            // If any trigger attribute match, move onto next attribute.
            // If the attribute between trigger and event dont match, move onto next event
        return 0
        }
    
    /**
     * By keeping track of used campaigns and saving the indices of the used events, check to make sure
     * the event passed in has never been used before.
     */
    fileprivate static func isEventAlreadyUsed(event: Event, usedMapping: [String: [Int]]) -> Bool {
        
        return false
    }
    
    fileprivate static func getNumberOfTimesTriggersMustBeSatisfied(_ campaign: Campaign) -> Int {
        let maxImpressions = campaign.campaignData.maxImpressions
        
        return 0
    }
    
    fileprivate static func isTriggerSatisfied(trigger: Trigger, event: Event) -> Bool {
    
        return false
    }
        
//        var campaignTriggerListMapping = [Int: Int]() // Mapping of the counter for each trigger needed for a campaign.
//
//        for trigger in campaignTriggers {
//            let eventType = trigger.eventType
//
//            // If a trigger is already added in the mapping, increment it.
//            if campaignTriggerListMapping.keys.contains(trigger.eventType) {
//                // Increment only event types that are not AppStart event since AppStart
//                // should be logged only once and is required for every campaign.
//                if campaignTriggerListMapping[eventType] != EventType.appStart.rawValue {
//                    campaignTriggerListMapping[eventType]? += 1
//                }
//            } else {
//                // else, add a new entry with the counter as 1.
//                campaignTriggerListMapping[eventType] = 1
//            }
//        }
        
//        var lowestNumberOfTimesSatisfied = Int.max
//
//        // Divide the event mapping with satisfiedTriggersCountMapping to
//        // get the number of times the set of triggers are satisfied.
//        // Find the lowest count satisfied trigger by dividing local event mapping and satisfiedTriggersCountMapping.
//        for (eventType, count) in campaignTriggerListMapping {
//            // If the local event mapping contains an entry of the campaign's trigger.
//            if let eventTypeMappingCount = localEventMapping[eventType]?.count {
//                // Swift, by default, rounds down for Int type when dividing.
//                let satisfiedCountForEventType = eventTypeMappingCount / count
//
//                // Find the lowest count from the list of triggers. E.G If a campaign
//                // has 2 triggers; one satisfied 3 times and the other 2 times, return 2.
//                lowestNumberOfTimesSatisfied =
//                    lowestNumberOfTimesSatisfied > satisfiedCountForEventType ?
//                        satisfiedCountForEventType : lowestNumberOfTimesSatisfied
//
//            } else {
//                // else if there is no entry, then the campaign's triggers have not been fully satisfied.
//                return 0
//            }
//        }
//
//        return lowestNumberOfTimesSatisfied != Int.max ? lowestNumberOfTimesSatisfied : 0

}


