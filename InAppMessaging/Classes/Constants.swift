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
    }
    
    /**
     * Constants for Event object.
     */
    struct Event {
        static let eventType = "eventType"
        static let timestamp = "timestamp"
        static let eventName = "eventName"
        static let customAttributes = "customAttributes"
        static let appStart = "APP_START"
        static let loginSuccessful = "LOGIN_SUCCESSFUL"
        static let purchaseSuccessful = "PURCHASE_SUCCESSFUL"
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
    
    /**
     * Key names for key value pairs.
     */
    struct KVObject {
        static let campaign = "campaign"
    }
}

