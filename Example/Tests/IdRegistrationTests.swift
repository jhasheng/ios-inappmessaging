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
//                let expected = [UserIdentifier]()
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
//                var expected = [UserIdentifier]()
//                expected.append(UserIdentifier(type: 2, id: "whales and dolphins"))
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
//                var expected = [UserIdentifier]()
//                
//                expected.append(UserIdentifier(type: 2, id: "whales and dolphins"))
//                expected.append(UserIdentifier(type: 1, id: "tigers and zebras"))
//
//                expect(expected).to(equal(IndentificationManager.userIdentifiers))
//            }
//        }
//    }
//}
