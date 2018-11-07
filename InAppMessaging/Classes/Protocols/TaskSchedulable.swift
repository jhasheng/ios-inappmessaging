protocol TaskSchedulable {
    
    // Save a reference to the work item in case of cancellation in the future.
    static var workItemReference: DispatchWorkItem? { get set }
    
    /**
     * Schedules a task to be ran after a certain delay. Keeps reference of the DispatchWorkItem
     * so that the work can be cancelled at any time.
     * @param { elay: Int } delay before running the task.
     * @param { task: DispatchWorkItem } a block of code to run after the delay.
     */
    func scheduleWorkItem(_ delay: Int, task: DispatchWorkItem)
}

/**
 * Default implementation.
 */
extension TaskSchedulable {
    func scheduleWorkItem(_ delay: Int, task: DispatchWorkItem) {

        Self.workItemReference?.cancel()
        Self.workItemReference = task
        if Self.workItemReference != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(delay), execute: Self.workItemReference!)
        }
    }
}
