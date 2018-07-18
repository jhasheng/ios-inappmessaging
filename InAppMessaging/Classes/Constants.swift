/**
 * Struct to organize all constants used by InAppMessaing SDK.
 */
struct Keys {
    
    /**
     * InAppMessaging URLs.
     */
    struct URL {
        static let ConfigServerURL = "InAppMessagingConfigURL"
        static let MixerServerURL = "InAppMessagingMixerServerURL"
    }
    
    /**
     * Constants used to build request body.
     */
    struct Request {
        static let AppID = "app_id"
        static let Platform = "platform"
        static let AppVersion = "app_version"
        static let SDKVersion = "sdk_version"
        static let Locale = "locale"
        static let SubscriptionID = "subscription_id"
    }
}
