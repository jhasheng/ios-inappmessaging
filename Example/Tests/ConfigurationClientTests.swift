/**
 *  Test class for ConfigurationClient.swift
 */

import XCTest
@testable import RakutenInsights

class ConfigurationClientTests: XCTestCase {
    
    /**
     * Mock class of CommonUtility. Purpose is to stub the method
     * retrieveFromMainBundle() to return predefined values in order to test
     * create behavior of other classes that utilizes CommonUtlity.
     */
    private class MockCommonUtility: CommonUtility {

        let strToRetrieve: String
        let stubRetrieveFromMainBundle: [String: Any?]
        let stubCallServer: [String: Any]?

        init(strToRetrieve: String, stubRetrieveFromMainBundle: [String: Any?], stubCallServer: [String: Any]?) {
            self.strToRetrieve = strToRetrieve
            self.stubRetrieveFromMainBundle = stubRetrieveFromMainBundle
            self.stubCallServer = stubCallServer
        }

        override func retrieveFromMainBundle(forKey: String) -> Any? {
            let dict = self.stubRetrieveFromMainBundle as? NSDictionary
            return dict?[strToRetrieve] as? String
        }
        
        override func callServer(withUrl: String, withHTTPMethod: String) -> [String: Any]? {
            return stubCallServer
        }
    }
    
    /**
     * Tests for the correct behavior of ConfigurationClient's checkConfigurationServer().
     * Based on two variables return from retrieveFromMainBundle() and callServer().
     * SDK should be true if and only if both variables returns something valid.
     */
    func testCheckConfigurationServer() {
        let stubDataForRetrieveFromMainBundle: [String: Any?] = [
            "RakutenInsightsConfigURL": "Catfish with Fashion",
            "ReturnNil": nil
        ]
        
        let stubDataForCallServer = [
            [
                "data": [
                    "enabled": true
                ]
            ],
            [
                "data": [
                    "enabled": false
                ]
            ]
        ]

        // True and true case
        var configurationClient = ConfigurationClient(commonUtility:
            MockCommonUtility(
                strToRetrieve: "RakutenInsightsConfigURL",
                stubRetrieveFromMainBundle: stubDataForRetrieveFromMainBundle,
                stubCallServer: stubDataForCallServer[0]))

        XCTAssertTrue(configurationClient.checkConfigurationServer())

        // True and false case
        configurationClient = ConfigurationClient(commonUtility:
            MockCommonUtility(
                strToRetrieve: "RakutenInsightsConfigURL",
                stubRetrieveFromMainBundle: stubDataForRetrieveFromMainBundle,
                stubCallServer: stubDataForCallServer[1]))

        XCTAssertFalse(configurationClient.checkConfigurationServer())

        // False and true case
        configurationClient = ConfigurationClient(commonUtility:
            MockCommonUtility(
                strToRetrieve: "ReturnNil",
                stubRetrieveFromMainBundle: stubDataForRetrieveFromMainBundle,
                stubCallServer: stubDataForCallServer[0]))

        XCTAssertFalse(configurationClient.checkConfigurationServer())

        // False and false case
        configurationClient = ConfigurationClient(commonUtility:
            MockCommonUtility(
                strToRetrieve: "ReturnNil",
                stubRetrieveFromMainBundle: stubDataForRetrieveFromMainBundle,
                stubCallServer: stubDataForCallServer[1]))

        XCTAssertFalse(configurationClient.checkConfigurationServer())
    }
}
