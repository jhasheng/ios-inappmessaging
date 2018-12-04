import Quick
import Nimble
@testable import InAppMessaging

/**
 * Tests for behavior of the SDK when supplied with different configuration responses.
 */
class ConfigurationTests: QuickSpec {

    class MockConfigurationClient: ConfigurationClient {
        var returnValueOfIsConfigEnabled: Bool
        
        init(isConfigEnabled: Bool) {
            self.returnValueOfIsConfigEnabled = isConfigEnabled
        }
        
        override func isConfigEnabled() -> Bool {
            return self.returnValueOfIsConfigEnabled
        }
    }
    
    class MockMessageMixer: MessageMixerClient {
        var enabledWasCalled = false
        
        override func ping() {
            self.enabledWasCalled = true
        }
    }
    
    override func spec() {
        context("InAppMessaging") {
            it("is disabled because configuration returned false") {
                let mockConfigurationClient = MockConfigurationClient(isConfigEnabled: false)
                let mockMessageMixer = MockMessageMixer()
                
                InAppMessaging.init(configurationClient: mockConfigurationClient, messageMixerClient: mockMessageMixer).initializeSdk()
                
                expect(mockMessageMixer.enabledWasCalled).to(equal(false))
                
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
