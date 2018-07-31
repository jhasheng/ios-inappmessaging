//
//  Bundle+IAM.swift
//  InAppMessaging
//
//  Created by Tam, Daniel a on 7/31/18.
//

import Foundation

extension Bundle {
    
    static var applicationId: String? {
        return Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String
    }
    
    static var buildVersion: String? {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    }
    
    static var inAppSdkVersion: String? {
        return Bundle.main.infoDictionary?[Keys.Bundle.SDKVersion] as? String
    }
    
    static var inAppSubscriptionId: String? {
        return Bundle.main.infoDictionary?[Keys.Bundle.SubscriptionID] as? String
    }
}
