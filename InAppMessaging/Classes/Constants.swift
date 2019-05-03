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
        static let deviceID = "device_id" // Snake_case rather than camelCase to unify with backend.
        static let authorization = "Authorization" // HTTP header for access token.
        static let subscriptionHeader = "Subscription-Id"// HTTP header for sub id.
    }
    
    /**
     * Constants for Event object.
     */
    struct Event {
        static let eventType = "eventType"
        static let timestamp = "timestamp"
        static let eventName = "eventName"
        static let customAttributes = "customAttributes"
        static let appStart = "app_start"
        static let loginSuccessful = "login_successful"
        static let purchaseSuccessful = "purchase_successful"
        static let invalid = "invalid"
        static let custom = "custom"
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
    
    /**
     * Constants for RAT SDK event names.
     */
    struct RAnalytics {
        static let impressions = "InAppMessaging_impressions"
        static let events = "InAppMessaging_events"
    }
}

