/**
 *  Test class for ServerConfiguration.swift
 */

import XCTest
@testable import RakutenInsights

class ServerConfigurationTests: XCTestCase {
    
    private class MockCommonUtility_with_value: CommonUtility {
        override func retrieveFromMainBundle(forKey: String) -> String? {
            return "Catfish with fashion"
        }
    }
    
    private class MockCommonUtility_without_value: CommonUtility {
        override func retrieveFromMainBundle(forKey: String) -> String? {
            return nil
        }
    }
    
    private class MockServerConfiguration_return_true: ServerConfiguration {
        override func callConfigurationServer(withUrl: String) -> Bool {
            return true
        }
    }
    
    private class MockServerConfiguration_return_false: ServerConfiguration {
        override func callConfigurationServer(withUrl: String) -> Bool {
            return false
        }
    }
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    /**
     * Test for behavior of checkConfigurationServer() when no value is returned from
     * CommonUtility.retrieveFromMainBundle() and callConfigurationServer() returns true.
     */
    func testCheckConfigurationServer_1() {
        let serverConfiguration =
            MockServerConfiguration_return_true(commonUtility: MockCommonUtility_without_value())
        
        XCTAssertFalse(serverConfiguration.checkConfigurationServer())
    }
    
    /**
     * Test for behavior of checkConfigurationServer() when a value is returned from
     * CommonUtility.retrieveFromMainBundle() and callConfigurationServer() returns true.
     */
    func testCheckConfigurationServer_2() {
        let serverConfiguration =
            MockServerConfiguration_return_true(commonUtility: MockCommonUtility_with_value())
        
        XCTAssertTrue(serverConfiguration.checkConfigurationServer())
    }
 
    /**
     * Test for behavior of checkConfigurationServer() when a value is returned from
     * CommonUtility.retrieveFromMainBundle() and callConfigurationServer() returns false.
     */
    func testCheckConfigurationServer_3() {
        let serverConfiguration =
            MockServerConfiguration_return_false(commonUtility: MockCommonUtility_with_value())
        
        XCTAssertFalse(serverConfiguration.checkConfigurationServer())
    }
    
    /**
     * Test for behavior of checkConfigurationServer() when no value is returned from
     * CommonUtility.retrieveFromMainBundle() and callConfigurationServer() returns false.
     */
    func testCheckConfigurationServer_4() {
        let serverConfiguration =
            MockServerConfiguration_return_false(commonUtility: MockCommonUtility_without_value())
        
        XCTAssertFalse(serverConfiguration.checkConfigurationServer())
    }
}
