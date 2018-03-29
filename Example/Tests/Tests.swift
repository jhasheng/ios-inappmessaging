import XCTest
@testable import RakutenInsights

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        var myDict: NSDictionary?
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            myDict = NSDictionary(contentsOfFile: path)
        }
        print(myDict)
        if let dict = myDict {
            print(dict["RakutenInsightsConfigURL"])
        }
 
    }

//    /**
//     * Retrieves the value of a specified key from main bundle.
//     * @param { forKey: String } key of the property to extract value from.
//     * @returns { Optional String } value of the key property.
//     */
//    internal func retrieveFromMainBundle(forKey: String) -> String? {
//        guard let valueOfPropertyToRetrieve = Bundle.main.infoDictionary?[forKey]  as? String else {
//            #if DEBUG
//                assertionFailure("Failed to retrieve '\(forKey)' from main bundle.")
//            #endif
//            return nil
//        }
//
//        return valueOfPropertyToRetrieve
//    }

    
}
