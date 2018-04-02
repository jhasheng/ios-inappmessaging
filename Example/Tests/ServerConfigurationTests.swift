/**
 *  Test class for ServerConfiguration.swift
 */

import XCTest
@testable import RakutenInsights

class ServerConfigurationTests: XCTestCase {
    
    private class MockCommonUtility: CommonUtility {
        
        let strToRetrieve: String
        let keyValueMapping: [String: Any?]
        
        init(strToRetrieve: String, keyValueMapping: [String: Any?]) {
            self.strToRetrieve = strToRetrieve
            self.keyValueMapping = keyValueMapping
        }
        
        override func retrieveFromMainBundle(forKey: String) -> String? {
            let dict = self.keyValueMapping[strToRetrieve] as? NSDictionary
            return dict!["return"]! as? String
        }
    }
    
    private class MockServerConfiguration: ServerConfiguration {
        
        var boolToReturn: Bool
        
        init(boolToReturn: Bool, commonUtility: CommonUtility) {
            self.boolToReturn = boolToReturn
            super.init(commonUtility: commonUtility)
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
        let dictForCommonUtility: [String: [String: Any?]] = [
            "1": [
                "return": "Catfish with fashion",
                "result": true
            ],
            "2": [
                "return": nil,
                "result": false
            ]
        ]
        
        for(key, value) in dictForCommonUtility {
            var serverConfiguration = MockServerConfiguration(
                boolToReturn: true,
                commonUtility: MockCommonUtility(strToRetrieve: key, keyValueMapping: dictForCommonUtility))

            XCTAssert(serverConfiguration.checkConfigurationServer() == value["result"] as! Bool)
            
            serverConfiguration = MockServerConfiguration(
                boolToReturn: false,
                commonUtility: MockCommonUtility(strToRetrieve: key, keyValueMapping: dictForCommonUtility))
            
            XCTAssertFalse(serverConfiguration.checkConfigurationServer())
        }
    }
}
