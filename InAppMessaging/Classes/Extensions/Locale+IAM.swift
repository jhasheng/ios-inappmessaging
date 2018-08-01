/**
 * Extension to Locale class to provide computed properties required by InAppMessaing.
 */
extension Locale {
    
    static var formattedCode: String? {
        return "\(Locale.current)".components(separatedBy: " ").first
    }
}
