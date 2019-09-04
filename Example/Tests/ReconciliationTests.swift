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
            EventRepository.clear()
        }
        
        context("ReadyCampaignRepo") {
            it("should only have test campaigns because no events are logged") {
                let mockResponse = TestConstants.MockResponse.twoTestCampaigns
                PingResponseRepository.list = mockResponse.data
                
                CampaignReconciliation.reconcile()
                
                expect(ReadyCampaignRepository.list.count).to(equal(2))
            }
            
            it("should have no campaigns if response has no test campaigns and no events logged") {
                let mockResponse = TestConstants.MockResponse.noTestCampaigns
                PingResponseRepository.list = mockResponse.data
                
                CampaignReconciliation.reconcile()
                
                expect(ReadyCampaignRepository.list.count).to(equal(0))
            }
            
            it("should have a campaign that is triggered by 1 LoginSuccessfulEvent") {
                let mockResponse = TestConstants.MockResponse.oneLoginSuccessfulEvent
                PingResponseRepository.list = mockResponse.data
                
                CampaignReconciliation.reconcile()
                expect(ReadyCampaignRepository.list.count).to(equal(0))

                EventRepository.addEvent(LoginSuccessfulEvent())
                CampaignReconciliation.reconcile()
                expect(ReadyCampaignRepository.list.count).toEventually(equal(1), timeout: 3.0, pollInterval: 0.1, description: nil)
            }
            
            it("should have a campaign that is matched using an custom event with a STRING type and EQUALS operator") {
                let mockResponse = TestConstants.MockResponse.stringTypeWithEqualsOperator
                PingResponseRepository.list = mockResponse.data

                let customEvent = CustomEvent(
                    withName: "testEvent",
                    withCustomAttributes: [
                        CustomAttribute(withKeyName: "attributeOne", withStringValue: "notAttributeOneValue")
                    ]
                )
                EventRepository.addEvent(customEvent)
                CampaignReconciliation.reconcile()
                expect(ReadyCampaignRepository.list.count).to(equal(0))
                
                let customEvent2 = CustomEvent(
                    withName: "testEvent",
                    withCustomAttributes: [
                        CustomAttribute(withKeyName: "attributeOne", withStringValue: "attributeOneValue")
                    ]
                )
                
                EventRepository.addEvent(customEvent2)
                CampaignReconciliation.reconcile()
                expect(ReadyCampaignRepository.list.count).to(equal(1))
            }
            
            it("should have a campaign that is matched using an custom event with a STRING type and IS_NOT_EQUAL operator") {
                let mockResponse = TestConstants.MockResponse.stringTypeWithNotEqualsOperator
                PingResponseRepository.list = mockResponse.data
                
                let customEvent = CustomEvent(
                    withName: "testEvent",
                    withCustomAttributes: [
                        CustomAttribute(withKeyName: "attributeOne", withStringValue: "attributeOneValue")
                    ]
                )
                EventRepository.addEvent(customEvent)
                CampaignReconciliation.reconcile()
                expect(ReadyCampaignRepository.list.count).to(equal(0))
                
                let customEvent2 = CustomEvent(
                    withName: "testEvent",
                    withCustomAttributes: [
                        CustomAttribute(withKeyName: "attributeOne", withStringValue: "notAttributeOneValue")
                    ]
                )
                
                EventRepository.addEvent(customEvent2)
                CampaignReconciliation.reconcile()
                expect(ReadyCampaignRepository.list.count).to(equal(1))
            }
            
            it("should have a campaign that is matched using an custom event with an INTEGER type and EQUALS operator") {
                let mockResponse = TestConstants.MockResponse.intTypeWithEqualsOperator
                PingResponseRepository.list = mockResponse.data
                
                let customEvent = CustomEvent(
                    withName: "testEvent",
                    withCustomAttributes: [
                        CustomAttribute(withKeyName: "attributeOne", withIntValue: 124)
                    ]
                )
                EventRepository.addEvent(customEvent)
                CampaignReconciliation.reconcile()
                expect(ReadyCampaignRepository.list.count).to(equal(0))
                
                let customEvent2 = CustomEvent(
                    withName: "testEvent",
                    withCustomAttributes: [
                        CustomAttribute(withKeyName: "attributeOne", withIntValue: 123)
                    ]
                )
                
                EventRepository.addEvent(customEvent2)
                CampaignReconciliation.reconcile()
                expect(ReadyCampaignRepository.list.count).to(equal(1))
            }
            
            it("should have a campaign that is matched using an custom event with an INTEGER type and IS_NOT_EQUAL operator") {
                let mockResponse = TestConstants.MockResponse.intTypeWithNotEqualsOperator
                PingResponseRepository.list = mockResponse.data
                
                let customEvent = CustomEvent(
                    withName: "testEvent",
                    withCustomAttributes: [
                        CustomAttribute(withKeyName: "attributeOne", withIntValue: 123)
                    ]
                )
                EventRepository.addEvent(customEvent)
                CampaignReconciliation.reconcile()
                expect(ReadyCampaignRepository.list.count).to(equal(0))
                
                let customEvent2 = CustomEvent(
                    withName: "testEvent",
                    withCustomAttributes: [
                        CustomAttribute(withKeyName: "attributeOne", withIntValue: 124)
                    ]
                )
                
                EventRepository.addEvent(customEvent2)
                CampaignReconciliation.reconcile()
                expect(ReadyCampaignRepository.list.count).to(equal(1))
            }
            
            it("should have a campaign that is matched using an custom event with an INTEGER type and GREATER_THAN operator") {
                let mockResponse = TestConstants.MockResponse.intTypeWithGreaterThanOperator
                PingResponseRepository.list = mockResponse.data
                
                let customEvent = CustomEvent(
                    withName: "testEvent",
                    withCustomAttributes: [
                        CustomAttribute(withKeyName: "attributeOne", withIntValue: 122)
                    ]
                )
                EventRepository.addEvent(customEvent)
                CampaignReconciliation.reconcile()
                expect(ReadyCampaignRepository.list.count).to(equal(0))
                
                let customEvent2 = CustomEvent(
                    withName: "testEvent",
                    withCustomAttributes: [
                        CustomAttribute(withKeyName: "attributeOne", withIntValue: 124)
                    ]
                )
                
                EventRepository.addEvent(customEvent2)
                CampaignReconciliation.reconcile()
                expect(ReadyCampaignRepository.list.count).to(equal(1))
            }
            
            it("should have a campaign that is matched using an custom event with an INTEGER type and LESS_THAN operator") {
                let mockResponse = TestConstants.MockResponse.intTypeWithLessThanOperator
                PingResponseRepository.list = mockResponse.data
                
                let customEvent = CustomEvent(
                    withName: "testEvent",
                    withCustomAttributes: [
                        CustomAttribute(withKeyName: "attributeOne", withIntValue: 124)
                    ]
                )
                EventRepository.addEvent(customEvent)
                CampaignReconciliation.reconcile()
                expect(ReadyCampaignRepository.list.count).to(equal(0))
                
                let customEvent2 = CustomEvent(
                    withName: "testEvent",
                    withCustomAttributes: [
                        CustomAttribute(withKeyName: "attributeOne", withIntValue: 122)
                    ]
                )
                
                EventRepository.addEvent(customEvent2)
                CampaignReconciliation.reconcile()
                expect(ReadyCampaignRepository.list.count).to(equal(1))
            }
            
            it("should have a campaign that is matched using an custom event with a DOUBLE type and EQUALS operator") {
                let mockResponse = TestConstants.MockResponse.doubleTypeWithEqualsOperator
                PingResponseRepository.list = mockResponse.data
                
                let customEvent = CustomEvent(
                    withName: "testEvent",
                    withCustomAttributes: [
                        CustomAttribute(withKeyName: "attributeOne", withDoubleValue: 124.0)
                    ]
                )
                EventRepository.addEvent(customEvent)
                CampaignReconciliation.reconcile()
                expect(ReadyCampaignRepository.list.count).to(equal(0))
                
                let customEvent2 = CustomEvent(
                    withName: "testEvent",
                    withCustomAttributes: [
                        CustomAttribute(withKeyName: "attributeOne", withDoubleValue: 123.0)
                    ]
                )
                
                EventRepository.addEvent(customEvent2)
                CampaignReconciliation.reconcile()
                expect(ReadyCampaignRepository.list.count).to(equal(1))
            }
            
            it("should have a campaign that is matched using an custom event with a DOUBLE type and IS_NOT_EQUAL operator") {
                let mockResponse = TestConstants.MockResponse.doubleTypeWithNotEqualsOperator
                PingResponseRepository.list = mockResponse.data
                
                let customEvent = CustomEvent(
                    withName: "testEvent",
                    withCustomAttributes: [
                        CustomAttribute(withKeyName: "attributeOne", withDoubleValue: 123.0)
                    ]
                )
                EventRepository.addEvent(customEvent)
                CampaignReconciliation.reconcile()
                expect(ReadyCampaignRepository.list.count).to(equal(0))
                
                let customEvent2 = CustomEvent(
                    withName: "testEvent",
                    withCustomAttributes: [
                        CustomAttribute(withKeyName: "attributeOne", withDoubleValue: 124.0)
                    ]
                )
                
                EventRepository.addEvent(customEvent2)
                CampaignReconciliation.reconcile()
                expect(ReadyCampaignRepository.list.count).to(equal(1))
            }
            
            it("should have a campaign that is matched using an custom event with a DOUBLE type and GREATER_THAN operator") {
                let mockResponse = TestConstants.MockResponse.doubleTypeWithGreaterThanOperator
                PingResponseRepository.list = mockResponse.data
                
                let customEvent = CustomEvent(
                    withName: "testEvent",
                    withCustomAttributes: [
                        CustomAttribute(withKeyName: "attributeOne", withDoubleValue: 122.0)
                    ]
                )
                EventRepository.addEvent(customEvent)
                CampaignReconciliation.reconcile()
                expect(ReadyCampaignRepository.list.count).to(equal(0))
                
                let customEvent2 = CustomEvent(
                    withName: "testEvent",
                    withCustomAttributes: [
                        CustomAttribute(withKeyName: "attributeOne", withDoubleValue: 124.0)
                    ]
                )
                
                EventRepository.addEvent(customEvent2)
                CampaignReconciliation.reconcile()
                expect(ReadyCampaignRepository.list.count).to(equal(1))
            }
            
            it("should have a campaign that is matched using an custom event with a DOUBLE type and LESS_THAN operator") {
                let mockResponse = TestConstants.MockResponse.doubleTypeWithLessThanOperator
                PingResponseRepository.list = mockResponse.data
                
                let customEvent = CustomEvent(
                    withName: "testEvent",
                    withCustomAttributes: [
                        CustomAttribute(withKeyName: "attributeOne", withDoubleValue: 124.0)
                    ]
                )
                EventRepository.addEvent(customEvent)
                CampaignReconciliation.reconcile()
                expect(ReadyCampaignRepository.list.count).to(equal(0))
                
                let customEvent2 = CustomEvent(
                    withName: "testEvent",
                    withCustomAttributes: [
                        CustomAttribute(withKeyName: "attributeOne", withDoubleValue: 122.0)
                    ]
                )
                
                EventRepository.addEvent(customEvent2)
                CampaignReconciliation.reconcile()
                expect(ReadyCampaignRepository.list.count).to(equal(1))
            }
            
            it("should have a campaign that is matched using an custom event with a BOOL type and EQUALS operator") {
                let mockResponse = TestConstants.MockResponse.boolTypeWithEqualsOperator
                PingResponseRepository.list = mockResponse.data
                
                let customEvent = CustomEvent(
                    withName: "testEvent",
                    withCustomAttributes: [
                        CustomAttribute(withKeyName: "attributeOne", withBoolValue: false)
                    ]
                )
                EventRepository.addEvent(customEvent)
                CampaignReconciliation.reconcile()
                expect(ReadyCampaignRepository.list.count).to(equal(0))
                
                let customEvent2 = CustomEvent(
                    withName: "testEvent",
                    withCustomAttributes: [
                        CustomAttribute(withKeyName: "attributeOne", withBoolValue: true)
                    ]
                )
                
                EventRepository.addEvent(customEvent2)
                CampaignReconciliation.reconcile()
                expect(ReadyCampaignRepository.list.count).to(equal(1))
            }
            
            it("should have a campaign that is matched using an custom event with a BOOL type and IS_NOT_EQUAL operator") {
                let mockResponse = TestConstants.MockResponse.boolTypeWithNotEqualOperator
                PingResponseRepository.list = mockResponse.data
                
                let customEvent = CustomEvent(
                    withName: "testEvent",
                    withCustomAttributes: [
                        CustomAttribute(withKeyName: "attributeOne", withBoolValue: true)
                    ]
                )
                EventRepository.addEvent(customEvent)
                CampaignReconciliation.reconcile()
                expect(ReadyCampaignRepository.list.count).to(equal(0))
                
                let customEvent2 = CustomEvent(
                    withName: "testEvent",
                    withCustomAttributes: [
                        CustomAttribute(withKeyName: "attributeOne", withBoolValue: false)
                    ]
                )
                
                EventRepository.addEvent(customEvent2)
                CampaignReconciliation.reconcile()
                expect(ReadyCampaignRepository.list.count).to(equal(1))
            }
            
            it("should have a campaign that is matched using an custom event with a time(int) type and EQUALS operator") {
                let mockResponse = TestConstants.MockResponse.timeTypeWithEqualsOperator
                PingResponseRepository.list = mockResponse.data
                
                let customEvent = CustomEvent(
                    withName: "testEvent",
                    withCustomAttributes: [
                        CustomAttribute(withKeyName: "attributeOne", withTimeInMilliValue: 1)
                    ]
                )
                EventRepository.addEvent(customEvent)
                CampaignReconciliation.reconcile()
                expect(ReadyCampaignRepository.list.count).to(equal(0))
                
                let customEvent2 = CustomEvent(
                    withName: "testEvent",
                    withCustomAttributes: [
                        CustomAttribute(withKeyName: "attributeOne", withTimeInMilliValue: 1099)
                    ]
                )
                
                EventRepository.addEvent(customEvent2)
                CampaignReconciliation.reconcile()
                expect(ReadyCampaignRepository.list.count).to(equal(1))
            }
            
            it("should have a campaign that is matched using an custom event with a time(int) type and IS_NOT_EQUAL operator") {
                let mockResponse = TestConstants.MockResponse.timeTypeWithNotEqualsOperator
                PingResponseRepository.list = mockResponse.data
                
                let customEvent = CustomEvent(
                    withName: "testEvent",
                    withCustomAttributes: [
                        CustomAttribute(withKeyName: "attributeOne", withTimeInMilliValue: 1099)
                    ]
                )
                EventRepository.addEvent(customEvent)
                CampaignReconciliation.reconcile()
                expect(ReadyCampaignRepository.list.count).to(equal(0))
                
                let customEvent2 = CustomEvent(
                    withName: "testEvent",
                    withCustomAttributes: [
                        CustomAttribute(withKeyName: "attributeOne", withTimeInMilliValue: 1)
                    ]
                )
                
                EventRepository.addEvent(customEvent2)
                CampaignReconciliation.reconcile()
                expect(ReadyCampaignRepository.list.count).to(equal(1))
            }
            
            it("should have a campaign that is matched using an custom event with a time(int) type and GREATER_THAN operator") {
                let mockResponse = TestConstants.MockResponse.timeTypeWithGreaterThanOperator
                PingResponseRepository.list = mockResponse.data
                
                let customEvent = CustomEvent(
                    withName: "testEvent",
                    withCustomAttributes: [
                        CustomAttribute(withKeyName: "attributeOne", withTimeInMilliValue: 1)
                    ]
                )
                EventRepository.addEvent(customEvent)
                CampaignReconciliation.reconcile()
                expect(ReadyCampaignRepository.list.count).to(equal(0))
                
                let customEvent2 = CustomEvent(
                    withName: "testEvent",
                    withCustomAttributes: [
                        CustomAttribute(withKeyName: "attributeOne", withTimeInMilliValue: 3000)
                    ]
                )
                
                EventRepository.addEvent(customEvent2)
                CampaignReconciliation.reconcile()
                expect(ReadyCampaignRepository.list.count).to(equal(1))
            }
            
            it("should have a campaign that is matched using an custom event with a time(int) type and LESS_THAN operator") {
                let mockResponse = TestConstants.MockResponse.timeTypeWithLessThanOperator
                PingResponseRepository.list = mockResponse.data
                
                let customEvent = CustomEvent(
                    withName: "testEvent",
                    withCustomAttributes: [
                        CustomAttribute(withKeyName: "attributeOne", withTimeInMilliValue: 2200)
                    ]
                )
                EventRepository.addEvent(customEvent)
                CampaignReconciliation.reconcile()
                expect(ReadyCampaignRepository.list.count).to(equal(0))
                
                let customEvent2 = CustomEvent(
                    withName: "testEvent",
                    withCustomAttributes: [
                        CustomAttribute(withKeyName: "attributeOne", withTimeInMilliValue: 1)
                    ]
                )
                
                EventRepository.addEvent(customEvent2)
                CampaignReconciliation.reconcile()
                expect(ReadyCampaignRepository.list.count).to(equal(1))
            }
            
            it("should have a campaign that is matched even with a case-insensitive event name") {
                let mockResponse = TestConstants.MockResponse.caseInsensitiveEventName
                PingResponseRepository.list = mockResponse.data
                
                let customEvent = CustomEvent(
                    withName: "TESTEVENT",
                    withCustomAttributes: [
                    ]
                )
                
                EventRepository.addEvent(customEvent)
                CampaignReconciliation.reconcile()
                expect(ReadyCampaignRepository.list.count).to(equal(1))
            }
            
            it("should have a campaign that is matched even with a case-insensitive attribute name") {
                let mockResponse = TestConstants.MockResponse.caseInsensitiveAttributeName
                PingResponseRepository.list = mockResponse.data
                
                let customEvent = CustomEvent(
                    withName: "TESTEVENT",
                    withCustomAttributes: [
                        CustomAttribute(withKeyName: "AtTriButeone", withStringValue: "hi")
                    ]
                )
                
                EventRepository.addEvent(customEvent)
                CampaignReconciliation.reconcile()
                expect(ReadyCampaignRepository.list.count).to(equal(1))
            }
            
            it("should not have a campaign because of case-sensitive attribute value mismatch") {
                let mockResponse = TestConstants.MockResponse.caseSensitiveAttributeValue
                PingResponseRepository.list = mockResponse.data
                
                let customEvent = CustomEvent(
                    withName: "TESTEVENT",
                    withCustomAttributes: [
                        CustomAttribute(withKeyName: "AtTriButeone", withStringValue: "hi")
                    ]
                )
                
                EventRepository.addEvent(customEvent)
                CampaignReconciliation.reconcile()
                expect(ReadyCampaignRepository.list.count).to(equal(0))
            }
        }
    }
}
