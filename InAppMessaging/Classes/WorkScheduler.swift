struct WorkScheduler {
    static private let inAppMessagingQueue = DispatchQueue(label: "InAppMessagingQueue", attributes: .concurrent)

    static func scheduleTask(_ delay: Int, closure: @escaping () -> ()) {
        inAppMessagingQueue.asyncAfter(deadline: .now() + .milliseconds(delay)) {
            closure()
        }
    }
}
