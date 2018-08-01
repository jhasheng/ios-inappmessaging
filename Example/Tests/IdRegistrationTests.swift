//
//  IdRegistrationTests.swift
//  InAppMessaging_Example
//
//  Created by Tam, Daniel a on 7/31/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import InAppMessaging

class idRegistrationTests: QuickSpec {
    
    override func spec() {
        
        beforeEach {
            IndentificationManager.userId = [[String: String]]()
        }
        
        context("ID Registration") {
            
            it("should not have any matching id type or id value") {
                let expected = [[String: String]]()
                
                expect(expected).toEventually(equal(IndentificationManager.userId))
            }
            
            /**
             * The two tests below calls directory from IndentificationManager.registerId rather than
             * InAppMessaging.registerId because the asynchronous nature in the public method causes
             * inconsistency when running the tests -- it sometimes fail.
             */
            it("should having one matching id type and id value") {
            
                IndentificationManager.registerId(.easyId, "whales and dolphins")
                
                // Build the expected object.
                var expected = [[String: String]]()
                var map = [String: String]()
                map["type"] = "easyId"
                map["id"] = "whales and dolphins"
                expected.append(map)
                
                expect(expected).to(equal(IndentificationManager.userId))
            }
            
            it("should having two matching id type and id value") {
                
                IndentificationManager.registerId(.easyId, "whales and dolphins")
                IndentificationManager.registerId(.rakutenId, "tigers and zebras")
                
                // Build the expected object.
                var expected = [[String: String]]()
                
                var firstMap = [String: String]()
                firstMap["type"] = "easyId"
                firstMap["id"] = "whales and dolphins"
                expected.append(firstMap)
                
                var secondMap = [String: String]()
                secondMap["type"] = "rakutenId"
                secondMap["id"] = "tigers and zebras"
                expected.append(secondMap)
                
                expect(expected).to(equal(IndentificationManager.userId))
            }
        }
    }
}
