@objc public class IAMPreferenceBuilder: NSObject {
    
    private var preference: IAMPreference
    
    override init() {
        self.preference = IAMPreference()
    }
    
    func setRakutenId(_ rakutenId: String) -> IAMPreferenceBuilder {
        self.preference.rakutenId = rakutenId
        return self
    }

    func setUserId(_ userId: String) -> IAMPreferenceBuilder {
        self.preference.userId = userId
        return self
    }

    func setAccessToken(_ accessToken: String) -> IAMPreferenceBuilder {
        self.preference.accessToken = accessToken
        return self
    }
    
    func build() -> IAMPreference {
        return self.preference
    }
}
