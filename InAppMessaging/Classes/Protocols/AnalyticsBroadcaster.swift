protocol AnalyticsBroadcaster {
    func sendEventName(_ name: String, _ dataObject: [String: Any]?)
}

extension AnalyticsBroadcaster {
    func sendEventName(_ name: String, _ dataObject: [String: Any]?) {
        var parameters = [String: Any]()
        parameters["eventName"] = name
        if let data = dataObject {
            parameters["eventData"] = dataObject
        }
        
        let notificationName = Notification.Name("com.rakuten.esd.sdk.events.custom")
        NotificationCenter.default.post(name: notificationName, object: parameters)
    }
}
