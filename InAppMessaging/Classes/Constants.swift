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
        static let AppID = "appId"
        static let Platform = "platform"
        static let AppVersion = "appVersion"
        static let SDKVersion = "sdkVersion"
        static let Locale = "locale"
    }
}
