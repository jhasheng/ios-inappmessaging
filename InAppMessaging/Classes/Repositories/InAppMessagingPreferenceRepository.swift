/**
 * Repository to hold IAMPreference.
 */
struct IAMPreferenceRepository {
    static var preference: IAMPreference?
    
    static func setPreference(with preference: IAMPreference) {
        self.preference = preference
    }
}
