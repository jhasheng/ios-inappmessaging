/**
 *  Test class for configurationClient.swift
 */

import XCTest
@testable import RakutenInsights

class ConfigurationClientTests: XCTestCase {
    
//    /**
//     * Mock class of CommonUtility. Purpose is to stub the method
//     * retrieveFromMainBundle() to return predefined values in order to test
//     * create behavior of other classes that utilizes CommonUtlity.
//     */
//    private class MockCommonUtility: CommonUtility {
//        
//        let strToRetrieve: String
//        let mockedPropertyValuesForKeys: [String: Any?]
//        
//        init(strToRetrieve: String, keyValueMapping: [String: Any?]) {
//            self.strToRetrieve = strToRetrieve
//            self.mockedPropertyValuesForKeys = keyValueMapping
//        }
//
//        override func retrieveFromMainBundle(forKey: String) -> Any? {
//            let dict = self.mockedPropertyValuesForKeys as? NSDictionary
//            return dict?[strToRetrieve] as? String
//        }
//    }
//    
//    /**
//     * Mock class of ConfigurationClient. Purpose is to stub the method
//     * callConfigurationServer() to mimic a response from backend server
//     * and test behavior based on the different responses.
//     */
//    private class MockServerConfiguration: configurationClient {
//        
//        var boolToReturn: Bool
//        
//        init(boolToReturn: Bool, mockedCommonUtility: CommonUtility) {
//            self.boolToReturn = boolToReturn
//            super.init(commonUtility: mockedCommonUtility)
//        }
//        
//        override func callConfigurationServer(withUrl: String) -> Bool {
//            return self.boolToReturn
//        }
//    }
    
//    /**
//     * Test for configurationClient's checkConfigurationServer() method.
//     * There are four results of the parameterized tests based on
//     * the two variables from configurationClient.callConfigurationServer()
//     * and CommonUtility.retrieveFromMainBundle().
//     */
//    func testCheckConfigurationServer() {
//        let stubDataForCommonUtility: [String: Any?] = [
//            "RakutenInsightsConfigURL": "Catfish with Fashion",
//            "ReturnNil": nil
//        ]
//
//        var configurationClient: MockServerConfiguration
//
//        // True and true case.
//        configurationClient = MockServerConfiguration(
//            boolToReturn: true,
//            mockedCommonUtility: MockCommonUtility(strToRetrieve: "RakutenInsightsConfigURL", keyValueMapping: stubDataForCommonUtility))
//
//        XCTAssertTrue(configurationClient.checkConfigurationServer())
//
//        // True and false case.
//        configurationClient = MockServerConfiguration(
//            boolToReturn: true,
//            mockedCommonUtility: MockCommonUtility(strToRetrieve: "ReturnNil", keyValueMapping: stubDataForCommonUtility))
//
//        XCTAssertFalse(configurationClient.checkConfigurationServer())
//
//        // False and true case.
//        configurationClient = MockServerConfiguration(
//            boolToReturn: false,
//            mockedCommonUtility: MockCommonUtility(strToRetrieve: "RakutenInsightsConfigURL", keyValueMapping: stubDataForCommonUtility))
//
//        XCTAssertFalse(configurationClient.checkConfigurationServer())
//
//        // False and false case.
//        configurationClient = MockServerConfiguration(
//            boolToReturn: false,
//            mockedCommonUtility: MockCommonUtility(strToRetrieve: "ReturnNil", keyValueMapping: stubDataForCommonUtility))
//
//        XCTAssertFalse(configurationClient.checkConfigurationServer())
//    }
}

