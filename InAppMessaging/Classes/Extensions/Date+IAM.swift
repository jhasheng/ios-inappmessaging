/**
 * Extension to Date class to provide computed properties required by InAppMessaging.
 */
extension Date {
    var millisecondsSince1970: Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
}
