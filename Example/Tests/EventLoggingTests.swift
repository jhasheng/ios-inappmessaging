//import Quick
//import Nimble
//@testable import InAppMessaging
//
///**
// * Tests for behavior of when manipulating with Plist using PlistManipulable protocol.
// */
//class EventLoggingTests: QuickSpec {
//
//    struct MockEventLogger: PlistManipulable {
//        static var plistURL: URL {
//            let documentDirectoryURL =  try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//            return documentDirectoryURL.appendingPathComponent(Keys.File.TestFileForEventLogs)
//        }
//    }
//
//    override func spec() {
//
//        beforeEach {
//            do {
//                try MockEventLogger.deletePropertyList()
//            } catch {}
//        }
//
//        afterSuite {
//            do {
//                try MockEventLogger.deletePropertyList()
//            } catch {}
//        }
//
//        context("Event logging") {
//
//            it("should throw an exception because theres no existing .plist file") {
//                expect {
//                    let eventLog: [Event] = try MockEventLogger.loadPropertyList()!
//                    return eventLog
//                }.to(throwError())
//            }
//
//            it("should not throw an exception because theres an existing .plist file") {
//
//                do {
//                    try MockEventLogger.savePropertyList([])
//                } catch {}
//                
//                expect {
//                    let eventLog: [Event] = try MockEventLogger.loadPropertyList()!
//                    return eventLog
//                }.toNot(throwError())
//            }
//        }
//    }
//}
