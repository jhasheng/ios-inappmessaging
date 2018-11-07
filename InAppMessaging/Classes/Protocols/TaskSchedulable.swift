protocol TaskSchedulable {
    
    // Save a reference to the work item in case of cancellation in the future.
    static var workItemReference: DispatchWorkItem? { get set }
    
    func scheduleWorkItem(_ delay: Int, task: DispatchWorkItem)
    
//    func cancelWorkItem()
}

extension TaskSchedulable {
    func scheduleWorkItem(_ delay: Int, task: DispatchWorkItem) {

        Self.workItemReference?.cancel()
        Self.workItemReference = task
        if Self.workItemReference != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(delay), execute: Self.workItemReference!)
        }
    }
    
//    func cancelWorkItem() {
//        if Self.workItemReference != nil {
//            Self.workItemReference!.cancel()
//        }
//    }
}
