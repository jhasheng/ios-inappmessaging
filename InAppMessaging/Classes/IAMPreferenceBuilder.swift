/**
 * Builder for IAMPreference. 
 */
@objc public class IAMPreferenceBuilder: NSObject {
    
    private var preference: IAMPreference
    
    override public init() {
        self.preference = IAMPreference()
    }
    
    public func setRakutenId(_ rakutenId: String) -> IAMPreferenceBuilder {
        self.preference.rakutenId = rakutenId
        return self
    }

    public func setUserId(_ userId: String) -> IAMPreferenceBuilder {
        self.preference.userId = userId
        return self
    }

    public func setAccessToken(_ accessToken: String) -> IAMPreferenceBuilder {
        self.preference.accessToken = accessToken
        return self
    }
    
    public func build() -> IAMPreference {
        return self.preference
    }
}
