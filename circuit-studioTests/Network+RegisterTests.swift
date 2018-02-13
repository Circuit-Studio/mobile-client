//
//  Network+RegisterTests.swift
//  circuit-studioTests
//
//  Created by Erick Sanchez on 2/6/18.
//  Copyright © 2018 Circuit Studio. All rights reserved.
//
//  A precompiler flag, TEST, is set to 1

import XCTest
import Quick
import Nimble
@testable import circuit_studio

class Network_RegisterTests: QuickSpec {
    
    override func spec() {
        super.spec()
        
        describe("register a user") {
            context("successfully and", {
                it("returns a success message from the api", closure: {
                    //TODO: custom endpoint, since success code needs to be 201 vs 200
                    LoginViewModel().register(a: UserHTTPBody(username: "unique", email: "unique@unique.com", password: "long_enough"), callback: { (result) in
                        switch result {
                        case .success:
                            _ = succeed()
                        case .failure(let errors):
                            fail(String(describing: errors.errors))
                        }
                    })
                })
            })
        }
    }
}
