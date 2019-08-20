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
    static func reconcile() {
        
        // Split the CampaignRepository into two different sets of test and non-test campaigns.
        let campaignList = CampaignParser.splitCampaigns(campaigns: PingResponseRepository.list)
        
        // Add all the test campaign into the ReadyCampaignRepository.
        ReadyCampaignRepository.addAllCampaigns(campaignList.testCampaigns)
        
        // Create a local event mapping used to quickly match event and trigger names.
        let localEventMapping = createEventMap(EventRepository.list) // Mapping of local events. [String: [Event]]
        
        // Iterate through all the non-test campaigns to verify each one.
        for campaign in campaignList.nonTestCampaigns {
            
            // Check if maxImpressions has already been reached for this campaign.
            if isMaxImpressionReached(forCampaign: campaign) {
                continue
            }
            
            // Add to ReadyCampaignRepo if the campaign's set of triggers are satisfied.
            // Message will not be added twice within one reconciliation process.
            if isCampaignReady(campaign, localEventMapping){
                ReadyCampaignRepository.addCampaign(campaign)
            }
        }
    }
    
    /**
     * Verifies that the campaign that is being reconciled on has not reached its max impression count within a session.
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
     * Check if the campaign's triggers are satisfied and is ready to be displayed.
     * A campaign is ready to be displayed if all of its triggers are satisfied.
     * @param { campaign: Campaign } campaign to check for.
     * @param { localEventMapping: [String: [Event]] } mapping of eventNames to events with same eventNames.
     * @return { Bool } whether or not the campaign is ready to be displayed.
     */
    private static func isCampaignReady(_ campaign: Campaign, _ localEventMapping: [String: [Event]]) -> Bool {
        
        // Get the list of triggers off the campaign.
        guard let campaignTriggers = campaign.campaignData.triggers else {
            #if DEBUG
                print("InAppMessaging: campaign has no triggers.")
            #endif
            return false
        }
        
        // Number of times the set of triggers must be satisfied.
        let numberOfTimesTriggersMustBeSatisfied = getNumberOfTimesTriggersMustBeSatisfied(campaign)
        
        // Mapping of already used events and its index.
        var mappingOfUsedEvents = [String: Set<Int>]()
        
        // Iterate through all the triggers for a specific campaign.
        for trigger in campaignTriggers {
            
            // Check if there is a record in the localEventMapping with the same trigger name.
            // If there is none, then the campaign's triggers cannot be fully satisfied.
            guard let listOfMatchingNameEvents  = extractRelevantEvents(trigger, localEventMapping) else {
                return false
            }
            
            // If the campaign trigger requires an APP_START event and a
            // single APP_START event is logged, then it is satisfied because
            // only one APP_START event should be logged. Continue to next trigger.
            if trigger.eventType == .appStart &&
                listOfMatchingNameEvents.count > 0 {

                    continue
            }
            
            // The amount of times that the current trigger that is being iterated upon has been satisfied.
            var amountOfTimesSatisfied: Int = 0
            
            // Iterate through the list of events with matching event name.
            // See how many times each trigger is satisfied.
            for (index, event) in listOfMatchingNameEvents.enumerated() {
                
                // Check if this event was already used for previous triggers.
                // If it is, move onto the next event.
                if isEventAlreadyUsed(eventName: event.eventName, currentIndex: index, usedMapping: mappingOfUsedEvents) {
                    continue
                }
                
                // If the trigger is satisfied.
                if isTriggerSatisfied(trigger, event) {
                    
                    // Append the index of this event to the mapping of used events so that
                    // it won't be used for other triggers in this campaign.
                    if mappingOfUsedEvents.keys.contains(event.eventName) {
                        mappingOfUsedEvents[event.eventName]?.insert(index)
                    } else {
                        mappingOfUsedEvents[event.eventName] = [index]
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
            
            // If the number of times the trigger must be satisfied doesnt meet
            // the requirement by the end iterating the list of event, then it
            // isn't fully satified and will return false.
            if (amountOfTimesSatisfied < numberOfTimesTriggersMustBeSatisfied) {
                return false
            }
        }
        
        return true
    }
    
    /**
     * Extracts from the localEventMapping all the events with the same eventName as the trigger passed in.
     * This helps the reconciliation process by not processing irrelevant events.
     * @param { trigger: Trigger } the trigger with the eventType and eventName to check for.
     * @param { localEventMap: [String: [Event]] } the localEventMap to cross reference with.
     * @returns { [Event]? } optional list of events that is relevant to the trigger.
     */
    fileprivate static func extractRelevantEvents(_ trigger: Trigger, _ localEventMap: [String: [Event]]) -> [Event]? {
        let eventType = trigger.eventType
        
        // If type is INVALID, return nil.
        if eventType == .invalid {
            return nil
        }
        
        var eventName: String
        
        // If event is a custom event, search by the name provided by the host app.
        if eventType == .custom {
            eventName = trigger.eventName
        } else {
            // If event is a pre-defined event, search by using the enum name.
            eventName = eventType.name
        }
        
        return localEventMap[eventName]
    }
    
    /**
     * By keeping track of used campaigns and saving the indices of the used events, check to make sure
     * the event passed in has never been used before.
     * @param { eventName: String } event of the event. This is used as the key for the usedMapping.
     * @param { currentIndex: Int } index of the event being processed.
     *      This is to check if the index is already in the usedMapping.
     * @param { usedMapping: [String: Set<Int>] } the records saved of the position of used events.
     * @returns { Bool } whether or not the event has been used before.
     */
    fileprivate static func isEventAlreadyUsed(eventName: String, currentIndex: Int, usedMapping: [String: Set<Int>]) -> Bool {
        
        // If there are no records of this eventName in the usedMapping, then
        // the event was never used before.
        guard let setOfEvents = usedMapping[eventName] else {
            return false
        }
        
        // If the current index is in the used mapping, then it was used before.
        if setOfEvents.contains(currentIndex) {
            return true
        }
        
        // Return false if event was never used before.
        return false
    }
    
    /**
     * Used to calculate how many times a set of triggers must be satified. It looks
     * at the maxImpression value of the campaign and also the times it was already displayed.
     * @param { campaign: Campaign } the campaign to test for.
     * @returns { Int } the number of times the triggers must be satisfied.
     */
    fileprivate static func getNumberOfTimesTriggersMustBeSatisfied(_ campaign: Campaign) -> Int {
        let maxImpressions = campaign.campaignData.maxImpressions
        let displayedCount = DisplayedCampaignRepository.getDisplayedCount(forCampaign: campaign)
        
        if displayedCount < maxImpressions {
            return displayedCount + 1
        }
        
        return 0
    }
    
    /**
     * Check if the trigger has been satisfied or not. A trigger is
     * satisfied if all of its attributes are satisfied.
     * @param { trigger: Trigger } the trigger to reconcile.
     * @param { event: Event } the event to match the trigger against.
     * @returns { Bool } whether or not the trigger and event matches.
     */
    fileprivate static func isTriggerSatisfied(_ trigger: Trigger, _ event: Event) -> Bool {
    
        // Iterate through all the trigger attributes.
        for triggerAttribute in trigger.attributes {
            
            // Return false if there isnt a matching trigger name between the trigger and event.
            guard let eventAttribute = event.getAttributeMap()?[triggerAttribute.name] else {
                return false
            }
            
            // Since there is a matching name between the trigger and event, see if the attributes are satisfied.
            if !isAttributeSatisfied(triggerAttribute, eventAttribute) {
                // If the attribute is not satisfied, then the trigger cannot be satisfied.
                return false
            }

        }
        
        // Return true since all the attributes are matched.
        return true
    }
    
    /**
     * Check if a trigger attribute and event attribute matches.
     * It is considered a match with several conditions:
     * 1) Event name for both matches.
     * 2) Event type for both matches.
     * 3) Both values satisfies the operator.
     * @param { triggerAttribute: TriggerAttribute } attribute of the trigger.
     * @param { eventAttribute: CustomAttribute } attribute of the event.
     * @returns { Bool } whether or not the attributes match.
     */
    fileprivate static func isAttributeSatisfied(_ triggerAttribute: TriggerAttribute, _ eventAttribute: CustomAttribute) -> Bool {
        
        // Make sure the attribute name and event attribute name is the same.
        if triggerAttribute.name != eventAttribute.name {
            return false
        }
        
        // Make sure the value type between the attribute value and event value is the same.
        if triggerAttribute.type != eventAttribute.type {
            return false
        }
        
        return isValueReconciled(
            withValueType: triggerAttribute.type,
            withOperator: triggerAttribute.operator,
            withTriggerAttributeValue: triggerAttribute.value,
            withEventAttributeValue: eventAttribute.value
        )
    }
    
    /**
     * Checks the attributes's value to see if they fit the operator.
     * It will cast the attribute's value to its proper type and
     * compare the values using the operator.
     * @param { valueType: AttributeType } value of the attributes.
     * @param { operatorType: AttributeOperator } the comparison operator used.
     * @param { triggerValue: String } value of the trigger attribute that will be casted to the eventType.
     * @param { eventValue: Any } the value of the event that will be casted to the eventType.
     * @returns { Bool } whether or not the values of both attributes are satisfied.
     */
    fileprivate static func isValueReconciled(
        withValueType valueType: AttributeType,
        withOperator operatorType: AttributeOperator,
        withTriggerAttributeValue triggerValue: String,
        withEventAttributeValue eventValue: Any) -> Bool {
        
        switch valueType {
            
            case .INVALID:
                return false
            
            case .STRING:
                guard let stringEventValue = eventValue as? String else {
                    #if DEBUG
                        print("InAppMessaging: Error converting value.")
                    #endif
                    return false
                }
            
                return MatchingUtil.compareValues(
                    withTriggerAttributeValue: triggerValue,
                    withEventAttributeValue: stringEventValue,
                    andOperator: operatorType
                )
            
            case .INTEGER:
                guard let intEventValue = eventValue as? Int,
                    let intTriggerValue = Int(triggerValue)
                else {
                    #if DEBUG
                        print("InAppMessaging: Error converting value.")
                    #endif
                    return false
                }
            
                return MatchingUtil.compareValues(
                    withTriggerAttributeValue: intTriggerValue,
                    withEventAttributeValue: intEventValue,
                    andOperator: operatorType
                )
            case .DOUBLE:
                guard let doubleEventValue = eventValue as? Double,
                    let doubleTriggerValue = Double(triggerValue)
                else {
                    #if DEBUG
                        print("InAppMessaging: Error converting value.")
                    #endif
                    return false
                }
            
                return MatchingUtil.compareValues(
                    withTriggerAttributeValue: doubleTriggerValue,
                    withEventAttributeValue: doubleEventValue,
                    andOperator: operatorType
                )
            
            case .BOOLEAN:
                guard let boolEventValue = eventValue as? Bool,
                    let boolTriggerValue = Bool(triggerValue.lowercased())
                else {
                    #if DEBUG
                        print("InAppMessaging: Error converting value.")
                    #endif
                    return false
                }
            
                return MatchingUtil.compareValues(
                    withTriggerAttributeValue: boolTriggerValue,
                    withEventAttributeValue: boolEventValue,
                    andOperator: operatorType
                )
            
            case .TIME_IN_MILLI:
                guard let timeEventValue = eventValue as? Int,
                    let timeTriggerValue = Int(triggerValue)
                else {
                    #if DEBUG
                        print("InAppMessaging: Error converting value.")
                    #endif
                    return false
                }
            
                return MatchingUtil.compareTimeValues(
                    withTriggerAttributeValue: timeTriggerValue,
                    withEventAttributeValue: timeEventValue,
                    andOperator: operatorType
                )
        }
    }
}
