import Quick
import Nimble
@testable import InAppMessaging

/**
 * Tests for reconciliation logic when provided different Ping responses.
 */
class ReconciliationTests: QuickSpec {
    
    class MockConfigurationClient: ConfigurationClient {
        var returnValueOfIsConfigEnabled: Bool
        
        init(isConfigEnabled: Bool) {
            self.returnValueOfIsConfigEnabled = isConfigEnabled
        }
        
        override func isConfigEnabled() -> Bool {
            return self.returnValueOfIsConfigEnabled
        }
    }
    
    override func spec() {
        
        beforeSuite {
            let mockConfigurationClient = MockConfigurationClient(isConfigEnabled: true)
            let mockMessageMixer = MessageMixerClient()
            
            InAppMessaging.init(configurationClient: mockConfigurationClient, messageMixerClient: mockMessageMixer).initializeSdk()
        }
        
        beforeEach {
            PingResponseRepository.clear()
            ReadyCampaignRepository.clear()
        }
        
        context("ReadyCampaignRepo") {
            it("should only have test campaigns because no events are logged") {
                let mockResponse = TestConstants.MockResponse.twoTestCampaigns
                PingResponseRepository.list = mockResponse.data
                
                CampaignReconciliation.reconciliate()
                
                expect(ReadyCampaignRepository.list.count).to(equal(2))
            }
            
            it("should have no campaigns if response has no test campaigns and no events logged") {
                let mockResponse = TestConstants.MockResponse.noTestCampaigns
                PingResponseRepository.list = mockResponse.data
                
                CampaignReconciliation.reconciliate()
                
                expect(ReadyCampaignRepository.list.count).to(equal(0))
            }
            
            it("should have a campaign that is triggered by 1 LoginSuccessfulEvent") {
                let mockResponse = TestConstants.MockResponse.oneLoginSuccessfulEvent
                PingResponseRepository.list = mockResponse.data
                
                CampaignReconciliation.reconciliate()
                expect(ReadyCampaignRepository.list.count).to(equal(0))

                InAppMessaging.logEvent(LoginSuccessfulEvent.init())
                expect(ReadyCampaignRepository.list.count).toEventuallyNot(equal(1), timeout: 3.0, pollInterval: 0.1, description: nil)
            }
        }
    }
}
