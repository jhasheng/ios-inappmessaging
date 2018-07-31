/**
 *  Test class for ConfigurationClient.swift
 */

import XCTest
import Swinject
@testable import InAppMessaging

class ConfigurationClientTests: XCTestCase {

    let stubDataForRetrieveFromMainBundle: [String: Any?] = [
        "InAppMessagingConfigURL": "Catfish with Fashion",
        "ReturnNil": nil
    ]

    let stubDataForCallServer = ["{\"data\": {\"enabled\": true,\"endpoints\": {\"ping\":\"\"}}}", // Enabled is true.
                                 "{\"data\": {\"enabled\": false,\"endpoints\": {\"ping\":\"\"}}}"] // Enabled is false.

    /**
     * Mock class of CommonUtility. Purpose is to stub the method
     * retrieveFromMainBundle() to return predefined values in order to test
     * create behavior of other classes that utilizes CommonUtlity.
     */
    private class MockCommonUtility: CommonUtility {

        let strToRetrieve: String
        let stubRetrieveFromMainBundle: [String: Any?]
        let stubCallServer: String?

        init(strToRetrieve: String, stubRetrieveFromMainBundle: [String: Any?], stubCallServer: String?) {
            self.strToRetrieve = strToRetrieve
            self.stubRetrieveFromMainBundle = stubRetrieveFromMainBundle
            self.stubCallServer = stubCallServer
        }

        override func retrieveFromMainBundle(forKey: String) -> Any? {
            let dict = self.stubRetrieveFromMainBundle as? NSDictionary
            return dict?[strToRetrieve] as? String
        }

        override func callServer(withUrl: String, withHTTPMethod: String) -> Data? {
            return self.stubCallServer!.data(using: .utf8)
        }
    }

    /**
     * Tests for the correct behavior of ConfigurationClient's isConfigEnabled().
     * Based on two variables return from retrieveFromMainBundle() and callServer().
     * SDK should be true if and only if both variables returns something valid.
     */
    func testCheckConfigurationServer1() {
        // True and true case
        let stubContainer = Container() { stubContainer in
            stubContainer.register(CommonUtility.self) { _ in
                MockCommonUtility(strToRetrieve: "InAppMessagingConfigURL",
                    stubRetrieveFromMainBundle: self.stubDataForRetrieveFromMainBundle,
                    stubCallServer: self.stubDataForCallServer[0]) }
        }

        InjectionContainer.container = stubContainer
        XCTAssertTrue(ConfigurationClient().isConfigEnabled())
    }

    func testCheckConfigurationServer2() {
        // True and false case
        let stubContainer = Container() { stubContainer in
            stubContainer.register(CommonUtility.self) { _ in
                MockCommonUtility(strToRetrieve: "InAppMessagingConfigURL",
                    stubRetrieveFromMainBundle: self.stubDataForRetrieveFromMainBundle,
                    stubCallServer: self.stubDataForCallServer[1]) }
        }

        InjectionContainer.container = stubContainer
        XCTAssertFalse(ConfigurationClient().isConfigEnabled())
    }

    func testCheckConfigurationServer3() {
        // False and true case
        let stubContainer = Container() { stubContainer in
            stubContainer.register(CommonUtility.self) { _ in
                MockCommonUtility(strToRetrieve: "ReturnNil",
                    stubRetrieveFromMainBundle: self.stubDataForRetrieveFromMainBundle,
                    stubCallServer: self.stubDataForCallServer[0]) }
        }

        InjectionContainer.container = stubContainer
        XCTAssertFalse(ConfigurationClient().isConfigEnabled())
    }

    func testCheckConfigurationServer4() {
        // False and false case
        let stubContainer = Container() { stubContainer in
            stubContainer.register(CommonUtility.self) { _ in
                MockCommonUtility(strToRetrieve: "ReturnNil",
                    stubRetrieveFromMainBundle: self.stubDataForRetrieveFromMainBundle,
                    stubCallServer: self.stubDataForCallServer[1]) }
        }

        InjectionContainer.container = stubContainer
        XCTAssertFalse(ConfigurationClient().isConfigEnabled())
    }
}
