protocol AnalyticsBroadcaster {
    func sendEventName(_ name: String, _ topLevelDataObject: [String: Any])
}
