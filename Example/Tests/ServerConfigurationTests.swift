/**
 *  Test class for ServerConfiguration.swift
 */

import XCTest
@testable import RakutenInsights

class ServerConfigurationTests: XCTestCase {
    
    /**
     * Mock class of CommonUtility. Purpose is to stub the method
     * retrieveFromMainBundle() to return predefined values in order to test
     * create behavior of other classes that utilizes CommonUtlity.
     */
    private class MockCommonUtility: CommonUtility {
        
        let strToRetrieve: String
        let mockedPropertyValuesForKeys: [String: Any?]
        
        init(strToRetrieve: String, keyValueMapping: [String: Any?]) {
            self.strToRetrieve = strToRetrieve
            self.mockedPropertyValuesForKeys = keyValueMapping
        }
        
        override func retrieveFromMainBundle(forKey: String) -> String? {
            let dict = self.mockedPropertyValuesForKeys[strToRetrieve] as? NSDictionary
            return dict!["return"]! as? String
        }
    }
    
    /**
     * Mock class of ServerConfiguration. Purpose is to stub the method
     * callConfigurationServer() to mimic a response from backend server
     * and test behavior based on the different responses.
     */
    private class MockServerConfiguration: ServerConfiguration {
        
        var boolToReturn: Bool
        
        init(boolToReturn: Bool, mockedCommonUtility: CommonUtility) {
            self.boolToReturn = boolToReturn
            super.init(commonUtility: mockedCommonUtility)
        }
        
        override func callConfigurationServer(withUrl: String) -> Bool {
            return self.boolToReturn
        }
    }
    
    /**
     * Test for ServerConfiguration's checkConfigurationServer() method.
     * There are four results of the parameterized tests based on
     * the two variables from ServerConfiguration.callConfigurationServer()
     * and CommonUtility.retrieveFromMainBundle().
     */
    func testCheckConfigurationServer() {
        let stubDataForCommonUtility: [String: [String: Any?]] = [
            "1": [
                "return": "Catfish with fashion",
                "result": true
            ],
            "2": [
                "return": nil,
                "result": false
            ]
        ]
        
        for(key, value) in stubDataForCommonUtility {
            var serverConfiguration = MockServerConfiguration(
                boolToReturn: true,
                mockedCommonUtility: MockCommonUtility(strToRetrieve: key, keyValueMapping: stubDataForCommonUtility))

            XCTAssert(serverConfiguration.checkConfigurationServer() == value["result"] as! Bool)
            
            serverConfiguration = MockServerConfiguration(
                boolToReturn: false,
                mockedCommonUtility: MockCommonUtility(strToRetrieve: key, keyValueMapping: stubDataForCommonUtility))
            
            XCTAssertFalse(serverConfiguration.checkConfigurationServer())
        }
    }
}
