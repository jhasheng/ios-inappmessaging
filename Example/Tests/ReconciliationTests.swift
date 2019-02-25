import Quick
import Nimble
@testable import InAppMessaging

/**
 * Tests for behavior of the SDK when supplied with different configuration responses.
 */
class ReconciliationTests: QuickSpec {
    
    override func spec() {
        
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
                
                InAppMessaging.logEvent(PurchaseSuccessfulEvent.init(withCustomAttributes: nil))
                CampaignReconciliation.reconciliate()
                expect(ReadyCampaignRepository.list.count).to(equal(1))

            }
        }
        
//        context("InAppMessaging") {
//            it("is disabled because configuration returned false") {
//                let mockConfigurationClient = MockConfigurationClient(isConfigEnabled: false)
//                let mockMessageMixer = MockMessageMixer()
//
//                InAppMessaging.init(configurationClient: mockConfigurationClient, messageMixerClient: mockMessageMixer).initializeSdk()
//
//                expect(mockMessageMixer.enabledWasCalled).to(equal(false))
//
//            }
//
//            it("is enabled because configuration returned true") {
//                let mockConfigurationClient = MockConfigurationClient(isConfigEnabled: true)
//                let mockMessageMixer = MockMessageMixer()
//
//                InAppMessaging.init(configurationClient: mockConfigurationClient, messageMixerClient: mockMessageMixer).initializeSdk()
//
//                expect(mockMessageMixer.enabledWasCalled).to(equal(true))
//            }
//        }
    }
}
