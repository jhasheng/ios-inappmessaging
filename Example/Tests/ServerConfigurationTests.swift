///**
// *  Test class for ServerConfiguration.swift
// */
//
//import XCTest
//@testable import RakutenInsights
//
//class ServerConfigurationTests: XCTestCase {
//    
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
//     * Mock class of ServerConfiguration. Purpose is to stub the method
//     * callConfigurationServer() to mimic a response from backend server
//     * and test behavior based on the different responses.
//     */
//    private class MockServerConfiguration: ServerConfiguration {
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
//    
//    /**
//     * Test for ServerConfiguration's checkConfigurationServer() method.
//     * There are four results of the parameterized tests based on
//     * the two variables from ServerConfiguration.callConfigurationServer()
//     * and CommonUtility.retrieveFromMainBundle().
//     */
//    func testCheckConfigurationServer() {
//        let stubDataForCommonUtility: [String: Any?] = [
//            "RakutenInsightsConfigURL": "Catfish with Fashion",
//            "ReturnNil": nil
//        ]
//        
//        var serverConfiguration: MockServerConfiguration
//        
//        // True and true case.
//        serverConfiguration = MockServerConfiguration(
//            boolToReturn: true,
//            mockedCommonUtility: MockCommonUtility(strToRetrieve: "RakutenInsightsConfigURL", keyValueMapping: stubDataForCommonUtility))
//
//        XCTAssertTrue(serverConfiguration.checkConfigurationServer())
//
//        // True and false case.
//        serverConfiguration = MockServerConfiguration(
//            boolToReturn: true,
//            mockedCommonUtility: MockCommonUtility(strToRetrieve: "ReturnNil", keyValueMapping: stubDataForCommonUtility))
//
//        XCTAssertFalse(serverConfiguration.checkConfigurationServer())
//
//        // False and true case.
//        serverConfiguration = MockServerConfiguration(
//            boolToReturn: false,
//            mockedCommonUtility: MockCommonUtility(strToRetrieve: "RakutenInsightsConfigURL", keyValueMapping: stubDataForCommonUtility))
//
//        XCTAssertFalse(serverConfiguration.checkConfigurationServer())
//
//        // False and false case.
//        serverConfiguration = MockServerConfiguration(
//            boolToReturn: false,
//            mockedCommonUtility: MockCommonUtility(strToRetrieve: "ReturnNil", keyValueMapping: stubDataForCommonUtility))
//
//        XCTAssertFalse(serverConfiguration.checkConfigurationServer())
//    }
//}

