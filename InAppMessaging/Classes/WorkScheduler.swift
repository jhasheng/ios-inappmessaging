/**
 * Struct to help dispatch function calls at a later time in a concurrent queue.
 */
struct WorkScheduler {
    
    static private let inAppMessagingQueue = DispatchQueue(label: "InAppMessagingQueue", attributes: .concurrent)

    /**
     * Function to schedule a function to be invoked at a later time.
     * @param { delay: Int } milliseconds before invoking the function.
     * @param { closure: Void -> Void } function to be invoked.
     */
    static func scheduleTask(_ delay: Int, closure: @escaping () -> ()) {
        inAppMessagingQueue.asyncAfter(deadline: .now() + .milliseconds(delay)) {
            closure()
        }
    }
}
