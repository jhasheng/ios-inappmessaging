class InAppMessagingPreferenceBuilder {
    
    private var preference: InAppMessagingPreference
    
    init() {
        self.preference = InAppMessagingPreference()
    }
    
    func setRakutenId(_ rakutenId: String) -> InAppMessagingPreferenceBuilder {
        self.preference.rakutenId = rakutenId
        return self
    }

    func setUserId(_ userId: String) -> InAppMessagingPreferenceBuilder {
        self.preference.userId = userId
        return self
    }

    func setAccessToken(_ accessToken: String) -> InAppMessagingPreferenceBuilder {
        self.preference.accessToken = accessToken
        return self
    }
    
    func build() -> InAppMessagingPreference {
        return self.preference
    }
}
