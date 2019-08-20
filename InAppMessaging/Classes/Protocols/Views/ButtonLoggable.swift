/**
 * Protcol that defines required methods and properties
 * to log attached events in buttons.
 */
protocol ButtonLoggable {
    var buttonMapping: [Int: (uri: String?, trigger: Trigger?)] { get }
    
    func logButtonTrigger(with tag: Int)
}

extension ButtonLoggable {
    /**
     * Handles the logging of an event of a button if a trigger is attached.
     * @param { tag: Int } the button's tag ID.
     */
    func logButtonTrigger(with tag: Int) {
        if let trigger = buttonMapping[tag]?.trigger {
            EventRepository.addEvent(CommonUtility.convertTriggerObjectToCustomEvent(trigger))
            CampaignReconciliation.reconciliate()
        }
    }
}
