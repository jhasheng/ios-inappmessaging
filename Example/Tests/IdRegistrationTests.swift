//import Quick
//import Nimble
//@testable import InAppMessaging
//
///**
// * Tests for behavior when registering IDs to the SDK.
// */
//class IdRegistrationTests: QuickSpec {
//    
//    override func spec() {
//        
//        beforeEach {
//            IndentificationManager.userIdentifiers.removeAll()
//        }
//        
//        context("ID Registration") {
//            
//            it("should not have any matching id type or id value") {
//                let expected = [[String: String]]()
//                
//                expect(expected).toEventually(equal(IndentificationManager.userIdentifiers))
//            }
//            
//            /**
//             * The two tests below calls directly from IndentificationManager.registerId() rather than
//             * InAppMessaging.registerId() because the asynchronous nature in the public method causes
//             * inconsistency when running the tests -- it sometimes fail. Running the non-async
//             * function will resolve this issue.
//             */
//            it("should have one matching id type and id value") {
//
//                IndentificationManager.registerId(.easyId, "whales and dolphins")
//
//                // Build the expected object.
//                var expected = [[String: AnyHashable]]()
//                var map = [String: AnyHashable]()
//                map["type"] = 2
//                map["id"] = "whales and dolphins"
//                expected.append(map)
//
//                expect(expected).to(equal(IndentificationManager.userIdentifiers))
//            }
//
//            it("should have two matching id type and id value") {
//
//                IndentificationManager.registerId(.easyId, "whales and dolphins")
//                IndentificationManager.registerId(.rakutenId, "tigers and zebras")
//
//                // Build the expected object.
//                var expected = [[String: AnyHashable]]()
//
//                var firstId = [String: AnyHashable]()
//                firstId["type"] = 2
//                firstId["id"] = "whales and dolphins"
//                expected.append(firstId)
//
//                var secondId = [String: AnyHashable]()
//                secondId["type"] = 1
//                secondId["id"] = "tigers and zebras"
//                expected.append(secondId)
//
//                expect(expected).to(equal(IndentificationManager.userIdentifiers))
//            }
//        }
//    }
//}
