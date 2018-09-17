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
        static let SubscriptionID = "subscriptionId"
        static let UserIdentifiers = "userIdentifiers"
        static let CampaignID = "campaignId"
        
        /**
         * Constants for Event object.
         */
        struct Event {
            static let name = "name"
            static let timestamp = "timestamp"
        }
    }
    
    /**
     * Directories used for SDK.
     */
    struct File {
        static let EventLogs = "InAppMessagingEventLogs.plist"
        static let TestFileForEventLogs = "InAppTests.plist"
    }
    
    /**
     * Key names for Info.plist.
     */
    struct Bundle {
        static let SDKVersion = "InAppMessagingSDKVersion"
        static let SubscriptionID = "InAppMessagingSubscriptionID"
    }
}

