//
//  EventLoggingTests.swift
//  InAppMessaging_Example
//
//  Created by Tam, Daniel a on 8/1/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import InAppMessaging

class EventLoggingTests: QuickSpec {
    
    struct MockEventLogger: EventLoggerProtocol {
        static var eventLog = [String: [Double]]()
        static var plistURL: URL {
            let documentDirectoryURL =  try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            return documentDirectoryURL.appendingPathComponent("InAppTests.plist")
        }
    }
    
    override func spec() {
        
        beforeEach {
            do {
                try FileManager.default.removeItem(at: MockEventLogger.plistURL)
            } catch {}
        }
        
        afterSuite {
            do {
                try FileManager.default.removeItem(at: MockEventLogger.plistURL)
            } catch {}
        }
        
        context("Event logging") {
            
            it("should throw an exception because theres no existing .plist file") {
                
                expect {
                    try print(MockEventLogger.loadPropertyList())
                }.to(throwError())
            }
            
            it("should not throw an exception because theres an existing .plist file") {
                
                do {
                    try MockEventLogger.savePropertyList([])
                } catch {}
                
                expect {
                    try print(MockEventLogger.loadPropertyList())
                }.toNot(throwError())
            }
        }
    }
}
