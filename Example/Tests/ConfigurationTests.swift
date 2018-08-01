//
//  ConfigurationTests.swift
//  InAppMessaging_Tests
//
//  Created by Tam, Daniel a on 7/31/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import InAppMessaging

class ConfigurationTests: QuickSpec {

    class MockConfigurationClient: ConfigurationClient {
        var returnValueOfIsConfigEnabled: Bool
        
        init(isConfigEnabled: Bool) {
            self.returnValueOfIsConfigEnabled = isConfigEnabled
        }
        
        override func isConfigEnabled() -> Bool {
            return true
        }
    }
    
    class MockMessageMixer: MessageMixerClient {
        var enabledWasCalled = false
        
        override func enable() {
            self.enabledWasCalled = true
        }
    }
    
    override func spec() {
        context("InAppMessaging") {
            it("is disabled because configuration returned false") {
                let mockConfigurationClient = MockConfigurationClient(isConfigEnabled: false)
                let mockMessageMixer = MockMessageMixer()
                
                InAppMessaging.init(configurationClient: mockConfigurationClient, messageMixerClient: mockMessageMixer).initializeSdk()
                
                expect(mockMessageMixer.enabledWasCalled).to(equal(true))
                
            }
            
            it("is enabled because configuration returned true") {
                let mockConfigurationClient = MockConfigurationClient(isConfigEnabled: true)
                let mockMessageMixer = MockMessageMixer()
                
                InAppMessaging.init(configurationClient: mockConfigurationClient, messageMixerClient: mockMessageMixer).initializeSdk()
                
                expect(mockMessageMixer.enabledWasCalled).to(equal(true))
            }
        }
    }
}
