//
//  Network+LoginTests.swift
//  circuit-studioTests
//
//  Created by Erick Sanchez on 2/11/18.
//  Copyright © 2018 Circuit Studio. All rights reserved.
//
//  A precompiler flag, TEST, is set to 1

import XCTest
import Quick
import Nimble
@testable import circuit_studio

class Network_LoginTests: QuickSpec {
    
    override func spec() {
        super.spec()
        
        describe("login a user") {
            context("successfully", {
                it("gets a token back", closure: {
                    let user = UserHTTPBody(username: "ununique", email: "ununique@ununique.ununique", password: "long_enough_password")
                    
                    LoginViewModel().login(a: user, callback: { (result) in
                        switch result {
                        case .success(let successData):
                            expect(successData.token).toNot(beNil())
                            expect(successData.username).toNot(beNil())
                            expect(successData.userId).toNot(beNil())
                        case .failure(let message):
                            fail(message.localizedDescription)
                        }
                    })
                })
            })
            
            context("unsuccessfully") {
                it("has missing fields", closure: {
                    waitUntil(timeout: 5, action: { (fullfilled) in
                        let user = UserHTTPBody(username: nil, email: nil, password: nil)
                        
                        LoginViewModel().login(a: user, callback: { (result) in
                            switch result {
                            case .success(let successData):
                                fail("wrong email was given \(String(describing: successData))")
                            case .failure(let resultError):
                                expect(resultError.errors.count).to(equal(1))
                                expect(resultError.errors[0])
                                    .to(equal("Cannot have empty fields."),
                                        description: "wrong api error message")
                                fullfilled()
                            }
                        })
                    })
                })
            }
            
            context("unsuccessfully") {
                it("has an incorrect password", closure: {
                    waitUntil(timeout: 5, action: { (fullfilled) in
                        let user = UserHTTPBody(username: "ununique", email: "ununique@ununique.ununique", password: "wront_password")
                        
                        LoginViewModel().login(a: user, callback: { (result) in
                            switch result {
                            case .success(let successData):
                                fail("wrong password was given \(String(describing: successData))")
                            case .failure(let resultError):
                                expect(resultError.errors.count).to(equal(1))
                                expect(resultError.errors[0])
                                    .to(equal("Please check credentials and try again."),
                                        description: "wrong api error message")
                                fullfilled()
                            }
                        })
                    })
                })
            }
            
            context("unsuccessfully") {
                it("has an incorrect email", closure: {
                    waitUntil(timeout: 5, action: { (fullfilled) in
                        let user = UserHTTPBody(username: nil, email: "wrong@wrong.wrong", password: "long_enough_password")
                        
                        LoginViewModel().login(a: user, callback: { (result) in
                            switch result {
                            case .success(let successData):
                                fail("wrong email was given \(String(describing: successData))")
                            case .failure(let resultError):
                                expect(resultError.errors.count).to(equal(1))
                                expect(resultError.errors[0])
                                    .to(equal("Please check credentials and try again."),
                                        description: "wrong api error message")
                                fullfilled()
                            }
                        })
                    })
                })
            }
        }
    }
}
